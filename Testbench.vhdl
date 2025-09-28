library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
entity Testbench is
end entity;
architecture Behave of Testbench is

constant number_of_inputs  : integer := 2;
constant number_of_outputs : integer := 40;

component DUT is
   port(input_vector: in std_logic_vector(number_of_inputs-1 downto 0);    
       	output_vector: out std_logic_vector(number_of_outputs-1 downto 0));
end component;

signal input_vector  : std_logic_vector(number_of_inputs-1 downto 0);
signal output_vector : std_logic_vector(number_of_outputs-1 downto 0);

function to_string(x: string) return string is
  variable ret_val: string(1 to x'length);
  alias lx : string(1 to x'length) is x;
begin  
  ret_val := lx;
  return(ret_val);
end to_string;

function to_std_logic_vector(x: bit_vector) return std_logic_vector is
  alias lx: bit_vector(1 to x'length) is x;
  variable ret_val: std_logic_vector(1 to x'length);
begin
  for I in 1 to x'length loop
     if(lx(I) = '1') then
       ret_val(I) := '1';
     else
       ret_val(I) := '0';
     end if;
  end loop; 
  return ret_val;
end to_std_logic_vector;

function to_bit_vector(x: std_logic_vector) return bit_vector is
  alias lx: std_logic_vector(1 to x'length) is x;
  variable ret_val: bit_vector(1 to x'length);
begin
  for I in 1 to x'length loop
     if(lx(I) = '1') then
       ret_val(I) := '1';
     else
       ret_val(I) := '0';
     end if;
  end loop; 
  return ret_val;
end to_bit_vector;

begin
process 
  variable err_flag : boolean := false;
  file INFILE: text open read_mode is "TRACEFILE.txt";
  file OUTFILE: text open write_mode is "outputs.txt";
  variable input_vector_var: bit_vector (number_of_inputs-1 downto 0);
  variable output_vector_var: bit_vector (number_of_outputs-1 downto 0);
  variable output_mask_var: bit_vector (number_of_outputs-1 downto 0);
  variable output_comp_var: std_logic_vector (number_of_outputs-1 downto 0);
  constant ZZZZ : std_logic_vector(number_of_outputs-1 downto 0) := (others => '0');
  variable INPUT_LINE: line;
  variable OUTPUT_LINE: line;
  variable LINE_COUNT: integer := 0;
begin

  -- Apply reset for first 20 ns
  input_vector <= "10"; -- input_vector(1)=clk dummy, input_vector(0)=reset high
  wait for 20 ns;
  input_vector <= "00"; -- release reset
  wait for 5 ns;

  while not endfile(INFILE) loop
    LINE_COUNT := LINE_COUNT + 1;

    readLine (INFILE, INPUT_LINE);
    read (INPUT_LINE, input_vector_var);
    read (INPUT_LINE, output_vector_var);
    read (INPUT_LINE, output_mask_var);

    input_vector <= to_std_logic_vector(input_vector_var);
    wait for 15 ns;

    output_comp_var := (to_std_logic_vector(output_mask_var) and 
                        (output_vector xor to_std_logic_vector(output_vector_var)));
    if (output_comp_var  /= ZZZZ) then
       write(OUTPUT_LINE,to_string("ERROR: line "));
       write(OUTPUT_LINE, LINE_COUNT);
       writeline(OUTFILE, OUTPUT_LINE);
       err_flag := true;
    end if;

    write(OUTPUT_LINE, to_bit_vector(input_vector));
    write(OUTPUT_LINE, to_string(" "));
    write(OUTPUT_LINE, to_bit_vector(output_vector));
    writeline(OUTFILE, OUTPUT_LINE);

    wait for 4 ns;
  end loop;

  assert (not err_flag) report "SUCCESS, all tests passed." severity note;
  assert (err_flag) report "FAILURE, some tests failed." severity error;

  wait;
end process;

dut_instance: DUT 
  port map(input_vector => input_vector, output_vector => output_vector);

end Behave;
