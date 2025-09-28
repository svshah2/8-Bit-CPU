library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity alu is
port(
a,b: in std_logic_vector(7 downto 0);
alusel: in std_logic_vector(2 downto 0);
result: out std_logic_vector(7 downto 0);
zero,carry: out std_logic

);

end alu;


architecture arc1 of alu is
signal ar,br,rr: unsigned(7 downto 0);
signal c: std_logic;
begin

ar<=unsigned(a);
br<=unsigned(b);

process(ar,br,alusel)
	variable arev,brev: unsigned(7 downto 0);
	variable temp: unsigned(8 downto 0);
	
	begin
	
	for i in 0 to 7 loop
		arev(i):= ar(7-i);
		brev(i):= br(7-i);
		end loop;

	temp := (others => '0');
	
	case alusel is
	when "000" => temp := ('0'& ar) + ('0'& br);
	when "001" => temp := ('0'& ar) - ('0'& br);
	when "010" => temp := ('0'& arev) + ('0'& brev);
	when "011" => temp(7 downto 0):= ar and br;
	when "100" => temp(7 downto 0):= ar or br;
	when "101" => temp(7 downto 0):= ar xor br;
	when others => temp(7 downto 0):= (others => '0');
	end case;
	
	rr<= temp(7 downto 0);
	result<=std_logic_vector(rr);
	
	if rr="00000000" then 
		zero<='1';
	else zero <='0';
	end if;
	
	
	carry<= temp(8);
	end process;
	end architecture arc1;
	
	
	