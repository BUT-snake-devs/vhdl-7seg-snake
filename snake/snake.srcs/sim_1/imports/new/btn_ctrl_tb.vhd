library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_btn_ctrl is
end tb_btn_ctrl;

architecture Behavioral of tb_btn_ctrl is

    constant CLK_PERIOD : time := 10 ns;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal btnu      : std_logic := '0';
    signal btnl      : std_logic := '0';
    signal btnd      : std_logic := '0';
    signal btnr      : std_logic := '0';
    signal btn_press : std_logic;
    signal btn_data  : std_logic_vector(1 downto 0);

begin

    uut: entity work.btn_ctrl
        generic map (
            DEBOUNCE_MAX => 2
        )
        port map (
            clk       => clk,
            rst       => rst,
            btnu      => btnu,
            btnl      => btnl,
            btnd      => btnd,
            btnr      => btnr,
            btn_press => btn_press,
            btn_data  => btn_data
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    stim_proc : process
    begin
        -- RESET #1
        report "RESET #1" severity note;
        rst  <= '1';
        btnu <= '0';
        btnl <= '0';
        btnd <= '0';
        btnr <= '0';
        wait for 50 ns;

        rst <= '0';
        wait for 50 ns;

        -- TEST 1: UP
        report "TEST 1: UP" severity note;
        btnu <= '1';
        wait for 80 ns;

        assert btn_press = '1'
            report "CHYBA: UP nevygenerovalo btn_press"
            severity error;

        assert btn_data = "00"
            report "CHYBA: UP ma spatne btn_data"
            severity error;

        btnu <= '0';
        wait for 80 ns;

        -- TEST 2: LEFT
        report "TEST 2: LEFT" severity note;
        btnl <= '1';
        wait for 80 ns;

        assert btn_press = '1'
            report "CHYBA: LEFT nevygenerovalo btn_press"
            severity error;

        assert btn_data = "01"
            report "CHYBA: LEFT ma spatne btn_data"
            severity error;

        btnl <= '0';
        wait for 80 ns;

        -- TEST 3: DOWN
        report "TEST 3: DOWN" severity note;
        btnd <= '1';
        wait for 80 ns;

        assert btn_press = '1'
            report "CHYBA: DOWN nevygenerovalo btn_press"
            severity error;

        assert btn_data = "10"
            report "CHYBA: DOWN ma spatne btn_data"
            severity error;

        btnd <= '0';
        wait for 80 ns;

        -- TEST 4: RIGHT
        report "TEST 4: RIGHT" severity note;
        btnr <= '1';
        wait for 80 ns;

        assert btn_press = '1'
            report "CHYBA: RIGHT nevygenerovalo btn_press"
            severity error;

        assert btn_data = "11"
            report "CHYBA: RIGHT ma spatne btn_data"
            severity error;

        btnr <= '0';
        wait for 80 ns;

        -- TEST 5: UP + LEFT soucasne -> nic
        report "TEST 5: UP + LEFT soucasne" severity note;
        btnu <= '1';
        btnl <= '1';
        wait for 80 ns;

        assert btn_press = '0'
            report "CHYBA: Pri soucasnem stisku UP+LEFT vznikl btn_press"
            severity error;

        btnu <= '0';
        btnl <= '0';
        wait for 80 ns;

        -- TEST 6: DOWN + RIGHT soucasne -> nic
        report "TEST 6: DOWN + RIGHT soucasne" severity note;
        btnd <= '1';
        btnr <= '1';
        wait for 80 ns;

        assert btn_press = '0'
            report "CHYBA: Pri soucasnem stisku DOWN+RIGHT vznikl btn_press"
            severity error;

        btnd <= '0';
        btnr <= '0';
        wait for 80 ns;

        -- TEST 7: drzim UP, pak zmacknu LEFT -> nic
        report "TEST 7: drzim UP, pak domacknu LEFT" severity note;
        btnu <= '1';
        wait for 80 ns;

        assert btn_press = '1'
            report "CHYBA: Prvni UP nevygenerovalo btn_press"
            severity error;

        assert btn_data = "00"
            report "CHYBA: Prvni UP ma spatne btn_data"
            severity error;

        wait for 40 ns;
        btnl <= '1';
        wait for 80 ns;

        assert btn_press = '0'
            report "CHYBA: Pri drzeni UP a domacknuti LEFT vznikl btn_press"
            severity error;

        btnu <= '0';
        btnl <= '0';
        wait for 80 ns;

        -- TEST 8: drzim RIGHT, pak zmacknu DOWN -> nic
        report "TEST 8: drzim RIGHT, pak domacknu DOWN" severity note;
        btnr <= '1';
        wait for 80 ns;

        assert btn_press = '1'
            report "CHYBA: Prvni RIGHT nevygenerovalo btn_press"
            severity error;

        assert btn_data = "11"
            report "CHYBA: Prvni RIGHT ma spatne btn_data"
            severity error;

        wait for 40 ns;
        btnd <= '1';
        wait for 80 ns;

        assert btn_press = '0'
            report "CHYBA: Pri drzeni RIGHT a domacknuti DOWN vznikl btn_press"
            severity error;

        btnr <= '0';
        btnd <= '0';
        wait for 80 ns;

        -- RESET #2
        report "RESET #2" severity note;
        rst <= '1';
        wait for 50 ns;

        assert btn_press = '0'
            report "CHYBA: btn_press je aktivni behem resetu"
            severity error;

        rst <= '0';
        wait for 50 ns;

        -- TEST 9: po resetu znovu LEFT
        report "TEST 9: LEFT po resetu" severity note;
        btnl <= '1';
        wait for 80 ns;

        assert btn_press = '1'
            report "CHYBA: LEFT po resetu nevygenerovalo btn_press"
            severity error;

        assert btn_data = "01"
            report "CHYBA: LEFT po resetu ma spatne btn_data"
            severity error;

        btnl <= '0';
        wait for 80 ns;

        report "VSE OK - TEST PROSEL" severity note;
        wait;
    end process;

end Behavioral;