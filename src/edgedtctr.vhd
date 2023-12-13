library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR0 is
    port (
        CLK     : in std_logic;
        SYNC_IN0 : in std_logic;
        EDGE0    : out std_logic
    ); 
end EDGEDTCTR0;

architecture BEHAVIORAL of EDGEDTCTR0 is
    signal sreg : std_logic_vector(2 downto 0);
    
begin
    
    process (CLK)
    begin
        if rising_edge(CLK) then
            sreg <= sreg(1 downto 0) & SYNC_IN0;
        end if;
    end process;
    
    with sreg select
    EDGE0 <= '1' when "100",
    '0' when others;
    
end BEHAVIORAL;