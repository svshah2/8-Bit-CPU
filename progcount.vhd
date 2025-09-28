library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity progcount is
port(

clk, reset, loadpc: in std_logic;
pcin : in std_logic_vector(7 downto 0);
pcout : out std_logic_vector(7 downto 0)


);
end progcount;

architecture arc3 of progcount is
signal pcreg: std_logic_vector(7 downto 0):=(others=>'0');
begin

	process(clk,reset)
		begin
			if(reset='1') then 
				pcreg<= (others => '0');
			elsif (rising_edge(clk)) then
				if(loadpc='1') then
					pcreg<=pcin;
				else
					pcreg<= std_logic_vector(unsigned(pcreg)+1);
				end if;
			end if;
		end process;
		
		pcout<= pcreg;
		end architecture arc3;
		