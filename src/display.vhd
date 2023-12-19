library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DISPLAY is
  generic (
    CLKIN_FREQ : positive := 100_000_000;
    --CLKIN_FREQ : positive :=       1_600;
    RFRSH_FREQ : positive :=         400
  );
  port (
    CODE_IN : in  STD_LOGIC_VECTOR(7 downto 0);
    RST_N   : in  STD_LOGIC;
    CLK     : in  STD_LOGIC;
    DONE    : in std_logic;
    SEGMENT : out std_logic_vector(6 downto 0);
    ANODE   : out std_logic_vector(3 downto 0);
    ANODO_A : out std_logic_vector(3 downto 0)
  );
end DISPLAY;

architecture Behavioral of DISPLAY is
    constant FACTOR : positive := CLKIN_FREQ / RFRSH_FREQ;

    signal strobe  : std_logic;
    signal anode_i : std_logic_vector(3 downto 0);
    signal salida1 : std_logic_vector (1 downto 0) := (others => '0') ;
 
begin
    ANODE <= anode_i;
    ANODO_A<= "1111";
    strober: process(RST_N, CLK)
        subtype count_t is integer range 0 to FACTOR - 1;
        variable count : count_t; 
    begin
        if RST_N = '0' then
            count := count_t'high;
            strobe <= '0';
        elsif rising_edge(CLK) then
            if count = 0 then
                strobe <= '1';
                count := count_t'high;
            else
                count := count - 1;
                strobe <= '0';
            end if;
        end if;
     end process;
 
     scanner: process (RST_N, CLK, anode_i)
     begin
        if RST_N = '0' then
            anode_i <= ('0', others => '1');
        elsif rising_edge(CLK) then
            if strobe = '1' then
                anode_i <= anode_i(0) & anode_i(anode_i'left downto 1);
            end if;
        end if;    
     end process;

    muxer: process (anode_i, CODE_IN) 
    begin
      
        case  anode_i is
            when "0111"=>
                salida1 <= CODE_IN(7 downto 6);
            when "1011"=>
                salida1 <= CODE_IN(5 downto 4);
            when "1101"=>
                salida1 <= CODE_IN(3 downto 2);
            when "1110"=>
                salida1 <= CODE_IN(1 downto 0);    
            when others=>
                salida1 <= "XX";
                
        end case;  
          
    end process;

    Decodificador: process(salida1,DONE)
    begin
        case salida1 is
            when "00"=>
                SEGMENT <= "0000001";
            when "01"=>
                SEGMENT <= "1001111"; 
            when "10" =>
                SEGMENT <= "0010010";    
            when "11" =>
                SEGMENT <= "0000110";    
            when others =>
                SEGMENT <= "1111111";    
        end case;
    end process;
end Behavioral;