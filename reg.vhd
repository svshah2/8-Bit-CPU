library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
port(
clk,we: in std_logic;
ra1,ra2,wa: in std_logic_vector(1 downto 0);
wd: in std_logic_vector(7 downto 0);
rd1,rd2: out std_logic_vector(7 downto 0)


);

end reg;

architecture arc2 of reg is
type regarr is array(3 downto 0) of std_logic_vector(7 downto 0);
signal regs: regarr:=(others=> (others=>'0'));
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if we='1' then 
			regs(to_integer(unsigned(wa))) <= wd;
			end if;
		end if;
end process;
			
			rd1<= regs(to_integer(unsigned(ra1)));
			rd2<= regs(to_integer(unsigned(ra2)));
end architecture arc2;
			
			
