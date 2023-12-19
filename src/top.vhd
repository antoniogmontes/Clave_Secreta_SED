library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
    generic (
        CLKIN_FREQ : positive := 100_000_000;
        RFRSH_FREQ : positive :=         400
    );
    PORT (
        CLK               : in  std_logic;                  -- Reloj
        boton             : in  std_logic_vector (4 downto 0);
        SWITCH            : in  std_logic;
        RESET             : in  std_logic;                  -- Señal de reset
        LEDRGB_comparador : out std_logic_vector(2 downto 0);
        LEDRGB_modo       : out std_logic_vector(2 downto 0);
        LED               : out std_logic_vector(3 downto 0);
        segmento          : out std_logic_vector(6 downto 0);
        anodo             : out std_logic_vector(3 downto 0)
    );
end top;

architecture structural of top is

    component fsm_mode
        PORT (
        CLK        : in std_logic;
        SWITCH     : in std_logic;
        MODE       : out std_logic;
        LEDRGB_OUT :out std_logic_vector(2 downto 0)
        );
        
    end component;
    
    component SYNCHRNZR0
        PORT (
          CLK      : in  std_logic;
          ASYNC_IN0 : in  std_logic;
          SYNC_OUT0 : out std_logic
        );
     end component;

     component EDGEDTCTR0
        PORT (
          CLK     : in std_logic;
          SYNC_IN0 : in std_logic;
          EDGE0    : out std_logic
        );
      end component;
      
    
  
    component DISPLAY
        generic (
            CLKIN_FREQ : positive := 100_000_000;
            RFRSH_FREQ : positive :=         400
        );
        PORT (
         CODE_IN : in  STD_LOGIC_VECTOR(7 downto 0);
         RST_N   : in  STD_LOGIC;
         CLK     : in  STD_LOGIC;
         DONE    :in std_logic;
         SEGMENT : out std_logic_vector(6 downto 0);
         ANODE   : out std_logic_vector(3 downto 0)
        );
    end component;
    component fsm_Cambiar_contrasena
        PORT (
           clk         : in STD_LOGIC;
           modo        : in STD_LOGIC;
           boton       : in STD_LOGIC_VECTOR (4 downto 0);
          -- antigua_Con : in STD_LOGIC_VECTOR (7 downto 0);
           new_Code    : out STD_LOGIC_VECTOR (7 downto 0);
           DONE1       :out std_logic;
           RESET       : in std_logic
        );
    end component;
    
    component fsm_Desbloquear
        PORT ( 
           clk       : in STD_LOGIC;
           modo      : in STD_LOGIC;
           boton     : in STD_LOGIC_VECTOR (4 downto 0);
           CODE_OUT  : out STD_LOGIC_VECTOR (7 downto 0);
           LED_OUT   : out STD_LOGIC_VECTOR (3 downto 0);
           DONE0     :out std_logic;
           RESET     : in std_logic
        );
    end component;  
component comparador
        PORT (
           CLK      : in std_logic; --Clock
           mode     : in std_logic; -- Selector de modo | Modo 0(Desbloquear) Modo 1(Nueva contraseña)
           new_Code : in std_logic_vector(7 downto 0); -- Nueva contaseña
           code_In  : in std_logic_vector(7 downto 0); -- Comprobar contraseña
           DONE0    : in std_logic;
           DONE1    : in std_logic; 
           led_RGB  : out std_logic_vector(2 downto 0) -- Led RGB
           --code_Out : out std_logic_vector(7 downto 0)
        );
    end component;    

    -- Señal intermedia para sincronización
    signal async_inputs : std_logic_vector(4 downto 0);
    signal syncd_inputs : std_logic_vector(4 downto 0);
    
    -- Señal intermedia para chipenable
    signal ce_signal : std_logic_vector(4 downto 0); 
    -- Señal intermedia para EL MODO
    signal mode_signal : std_logic;  
    -- Señal intermedia para CODEOUT DEL DESBLOQUEAR
    signal codeout_signal : std_logic_vector(7 downto 0);
    -- Señal intermedia para mantiene la antigua contraseña
--signal antigua_signal : std_logic_vector(7 downto 0);
    -- Señal intermedia para codeut cambia
    signal newcode_signal : std_logic_vector(7 downto 0);
    --señales confirmacion maquinas de estados
    signal done0_signal :std_logic;
    signal done1_signal :std_logic;
       
begin
    async_inputs <= boton;
--    syncd_inputs : std_logic_vector(5 downto 0);

fsm_mode_inst: fsm_mode
    PORT MAP(
        CLK        => CLK,
        SWITCH     => SWITCH,
        MODE       => mode_signal,
        LEDRGB_OUT => LEDRGB_modo    
    );

    syncrs: for i in 0 to 4 generate
    begin
        synchro_inst: SYNCHRNZR0
            port map (
              CLK       => clk,
              ASYNC_IN0 => async_inputs(i),
              SYNC_OUT0 => syncd_inputs(i) 
            );
         Edgdtcrtr_inst: EDGEDTCTR0
            PORT MAP(
                CLK => CLK,
                SYNC_IN0=>syncd_inputs(i),
                EDGE0 => ce_signal(i)
            );  
    end generate;

fsm_Desbloquear_inst: fsm_Desbloquear
    PORT MAP(
        CLK=>CLK,
        MODO=>mode_signal,
        RESET=>RESET,
        DONE0=>done0_signal,
        boton(0)=>ce_signal(0),
        boton(1)=>ce_signal(1),
        boton(2)=>ce_signal(2),
        boton(3)=>ce_signal(3),
        boton(4)=>ce_signal(4),
        CODE_OUT=>codeout_signal,
        LED_OUT=>LED
         
    );
fsm_cambiar_contrasena_inst: fsm_Cambiar_contrasena
    PORT MAP(
        CLK=>CLK,
        modo=>mode_signal,
        RESET=>RESET,
        DONE1=>done1_signal,
        boton(0)=>ce_signal(0),
        boton(1)=>ce_signal(1),
        boton(2)=>ce_signal(2),
        boton(3)=>ce_signal(3),
        boton(4)=>ce_signal(4),
        --antigua_con=>antigua_signal,
        new_code =>newcode_signal
    );    
Display_inst: DISPLAY
    generic map (
        CLKIN_FREQ => CLKIN_FREQ,
        RFRSH_FREQ => RFRSH_FREQ
    )
    PORT MAP(
        RST_N=>RESET,
        DONE=>done1_signal,
        CODE_IN=>newcode_signal,
        CLK=>CLK,
        ANODE=>ANODO,
        SEGMENT=>segmento 
    );
Comparador_inst: comparador
    PORT MAP(
        CLK=>CLK,
        MODE=>mode_signal,
        DONE0=>done0_signal,
        DONE1=>done1_signal,
        new_Code=>newcode_signal,
        Code_In=>codeout_signal,
        --Code_Out=>antigua_signal,
        Led_RGB=>LEDRGB_comparador
    );                     
end structural;