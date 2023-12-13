library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR0 is
     port (
        CLK      : in std_logic; 
        ASYNC_IN0 : in std_logic;
        SYNC_OUT0 : out std_logic
     );
end SYNCHRNZR0;

architecture BEHAVIORAL of SYNCHRNZR0 is
    signal sreg : std_logic_vector(1 downto 0);

begin
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            sync_out0 <= sreg(1);
            sreg <= sreg(0) & async_in0;
        end if;
    end process;
end BEHAVIORAL;

