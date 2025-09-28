-- A DUT entity is used to wrap your design so that we can combine it with testbench.
-- This example shows how you can do this for the OR Gate

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(input_vector: in std_logic_vector(1 downto 0);
       	output_vector: out std_logic_vector(39 downto 0));
end entity;

architecture DutWrap of DUT is
component cpu is
    port(
        clk, reset : in std_logic;
        pcout_out  : out std_logic_vector(7 downto 0);
        rd1_out    : out std_logic_vector(7 downto 0);
        rd2_out    : out std_logic_vector(7 downto 0);
        result_out : out std_logic_vector(7 downto 0);
        dataout_out: out std_logic_vector(7 downto 0)
    );
end component;



begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: cpu
			port map (
					-- order of inputs B A

clk => input_vector(1),
reset => input_vector(0),




					
               -- order of output OUTPUT
pcout_out => output_vector(39 downto 32),
rd1_out => output_vector(31 downto 24),
rd2_out => output_vector(23 downto 16),
result_out => output_vector(15 downto 8),
dataout_out => output_vector(7 downto 0)

					);
end DutWrap;