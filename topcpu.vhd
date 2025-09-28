library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is

port(
clk,reset: in std_logic;
pcout_out,rd1_out,rd2_out,result_out,dataout_out: out std_logic_vector(7 downto 0)
);
end cpu;

architecture arccpu of cpu is

signal rd1,rd2,wd,result: std_logic_vector(7 downto 0);
signal zero,carry: std_logic;
signal alusel: std_logic_vector(2 downto 0);
signal we,loadpc: std_logic;
signal pcin,pcout,datain,dataout: std_logic_vector(7 downto 0);

begin
uReg: entity work.reg port map(clk=>clk,we=>we,ra1=>"00",ra2=>"01",wa=>"10",wd=>wd,rd1=>rd1,rd2=>rd2);
uALU: entity work.alu port map(a=>rd1,b=>rd2,alusel=>alusel,result=>result,zero=>zero,carry=>carry);
uPC: entity work.progcount port map(clk=>clk,reset=>reset,loadpc=>loadpc,pcin=>pcin,pcout=>pcout);
uRAM: entity work.myram port map(clk=>clk,we=>we,add=>pcout,datain=>wd,dataout=>dataout);


pcout_out<=pcout;
rd1_out<=rd1;
rd2_out<=rd2;
result_out<=result;
dataout_out<=dataout;

end architecture arccpu;
