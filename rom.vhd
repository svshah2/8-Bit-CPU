library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myrom is
port(

add: in std_logic_vector(7 downto 0);
instrout: out std_logic_vector(7 downto 0)

);
end myrom;

architecture arc5 of myrom is
	type bigrom is array(0 to 255) of std_logic_vector(7 downto 0);
	signal rom: bigrom := (0=> x"10", 1=> x"21", others => x"00");
	begin
	instrout<= rom(to_integer(unsigned(add)));
	end architecture arc5;
	

