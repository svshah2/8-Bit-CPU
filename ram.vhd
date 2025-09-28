library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myram is
port(
clk,we: in std_logic;
add,datain: in std_logic_vector(7 downto 0);
dataout: out std_logic_vector(7 downto 0)


);

end myram;

architecture arc4 of myram is
type ramarr is array(0 to 255) of std_logic_vector(7 downto 0);
signal ram : ramarr := (others => (others => '0'));
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(we='1') then
				ram(to_integer(unsigned(add)))<= datain;
				end if;
				
			dataout<= ram(to_integer(unsigned(add)));
			end if;
		end process;
		
end architecture arc4;