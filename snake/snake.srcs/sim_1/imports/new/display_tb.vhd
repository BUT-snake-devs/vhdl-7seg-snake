library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_display is
end tb_display;

architecture Behavioral of tb_display is

    -- DUT signals
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal x_pos : std_logic_vector(3 downto 0) := (others => '0');
    signal y_pos : std_logic_vector(2 downto 0) := (others => '0');
    signal an    : std_logic_vector(7 downto 0);
    signal seg   : std_logic_vector(6 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instance of DUT
    uut: entity work.display
        port map (
            clk   => clk,
            rst   => rst,
            x_pos => x_pos,
            y_pos => y_pos,
            an    => an,
            seg   => seg
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset
        rst <= '1';
        x_pos <= "0000";
        y_pos <= "000";
        wait for 3 * CLK_PERIOD;

        rst <= '0';
        wait for 2 * CLK_PERIOD;

        -- Ručně vybrané kombinace pro lepší čitelnost v průbězích

        -- x = 0, y = 1 -> segment B
        x_pos <= "0000";
        y_pos <= "001";
        wait for 3 * CLK_PERIOD;

        -- x = 0, y = 3 -> segment C
        x_pos <= "0000";
        y_pos <= "011";
        wait for 3 * CLK_PERIOD;

        -- x = 1, y = 0 -> A
        x_pos <= "0001";
        y_pos <= "000";
        wait for 3 * CLK_PERIOD;

        -- x = 1, y = 1 -> F
        x_pos <= "0001";
        y_pos <= "001";
        wait for 3 * CLK_PERIOD;

        -- x = 1, y = 2 -> G
        x_pos <= "0001";
        y_pos <= "010";
        wait for 3 * CLK_PERIOD;

        -- x = 1, y = 3 -> E
        x_pos <= "0001";
        y_pos <= "011";
        wait for 3 * CLK_PERIOD;

        -- x = 1, y = 4 -> D
        x_pos <= "0001";
        y_pos <= "100";
        wait for 3 * CLK_PERIOD;

        -- x = 2, y = 0..4
        x_pos <= "0010";
        y_pos <= "000";
        wait for 3 * CLK_PERIOD;

        y_pos <= "001";
        wait for 3 * CLK_PERIOD;

        y_pos <= "010";
        wait for 3 * CLK_PERIOD;

        y_pos <= "011";
        wait for 3 * CLK_PERIOD;

        y_pos <= "100";
        wait for 3 * CLK_PERIOD;

        -- x = 5, y = 2
        x_pos <= "0101";
        y_pos <= "010";
        wait for 3 * CLK_PERIOD;

        -- x = 8, y = 4
        x_pos <= "1000";
        y_pos <= "100";
        wait for 3 * CLK_PERIOD;

        -- projití celé menší sady automaticky
        for x in 0 to 7 loop
            for y in 0 to 4 loop
                x_pos <= std_logic_vector(to_unsigned(x, x_pos'length));
                y_pos <= std_logic_vector(to_unsigned(y, y_pos'length));
                wait for 2 * CLK_PERIOD;
            end loop;
        end loop;

        wait;
    end process;

end Behavioral;