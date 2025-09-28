library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsmcont is
    port (
        clk, reset : in std_logic;
        instrout   : in std_logic_vector(7 downto 0);
        rd1, rd2   : in std_logic_vector(7 downto 0);
        result     : in std_logic_vector(7 downto 0);
        dataout    : in std_logic_vector(7 downto 0);
        pcout      : in std_logic_vector(7 downto 0);
        we, memwe, loadpc : out std_logic;
        wa : out std_logic_vector(1 downto 0);
        wd, a, b, datain, pcin, add : out std_logic_vector(7 downto 0);
        alusel : out std_logic_vector(2 downto 0)
    );
end fsmcont;

architecture arc6 of fsmcont is
    type state_type is (FETCH, DECODE, EXECUTE, WRITEBACK);
    signal state, next_state : state_type;
    signal opcode : std_logic_vector(3 downto 0);
    signal reg_dst, reg_src : std_logic_vector(1 downto 0);
    signal imm_val : std_logic_vector(7 downto 0);
begin
    opcode   <= instrout(7 downto 4);
    reg_dst  <= instrout(3 downto 2);
    reg_src  <= instrout(1 downto 0);
    imm_val  <= instrout;

    process(clk, reset)
    begin
        if reset = '1' then
            state <= FETCH;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    process(state, instrout, rd1, rd2, result, dataout, pcout)
    begin
        we <= '0'; memwe <= '0'; loadpc <= '0';
        a <= (others => '0'); b <= (others => '0'); alusel <= (others => '0');
        wa <= (others => '0'); wd <= (others => '0');
        add <= (others => '0'); datain <= (others => '0'); pcin <= (others => '0');
        next_state <= FETCH;
        case state is
            when FETCH =>
                add <= pcout;
                next_state <= DECODE;
            when DECODE =>
                next_state <= EXECUTE;
            when EXECUTE =>
                case opcode is
                    when "0000" => a <= rd1; b <= rd2; alusel <= "000"; next_state <= WRITEBACK;
                    when "0001" => a <= rd1; b <= rd2; alusel <= "001"; next_state <= WRITEBACK;
                    when "0010" => a <= rd1; b <= rd2; alusel <= "010"; next_state <= WRITEBACK;
                    when "0011" => a <= rd1; b <= rd2; alusel <= "011"; next_state <= WRITEBACK;
                    when "0100" => a <= rd1; b <= rd2; alusel <= "100"; next_state <= WRITEBACK;
                    when "0101" => a <= rd1; b <= rd2; alusel <= "101"; next_state <= WRITEBACK;
                    when "0110" => add <= rd1; next_state <= WRITEBACK;
                    when "0111" => next_state <= WRITEBACK;
                    when "1000" => add <= rd1; datain <= rd2; memwe <= '1'; next_state <= FETCH;
                    when others => next_state <= FETCH;
                end case;
            when WRITEBACK =>
                case opcode is
                    when "0000" | "0001" | "0010" | "0011" | "0100" | "0101" =>
                        wa <= reg_dst; wd <= result; we <= '1'; next_state <= FETCH;
                    when "0110" =>
                        wa <= reg_dst; wd <= dataout; we <= '1'; next_state <= FETCH;
                    when "0111" =>
                        wa <= reg_dst; wd <= imm_val; we <= '1';
                        if reg_dst = "00" then loadpc <= '1'; pcin <= imm_val; end if;
                        next_state <= FETCH;
                    when others => next_state <= FETCH;
                end case;
        end case;
    end process;
end arc6;
