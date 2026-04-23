library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tail_tb is
end tail_tb;

architecture Behavioral of tail_tb is

    component tail is
        Port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            en_speed    : in  STD_LOGIC;
            en_mux      : in  STD_LOGIC;
            x_pos_i     : in  STD_LOGIC_VECTOR (3 downto 0);
            y_pos_i     : in  STD_LOGIC_VECTOR (2 downto 0);
            lenght      : in  STD_LOGIC_VECTOR (5 downto 0);
            x_pos_o     : out STD_LOGIC_VECTOR (3 downto 0);
            y_pos_o     : out STD_LOGIC_VECTOR (2 downto 0);
            bite_itself : out STD_LOGIC
        );
    end component;

    signal clk         : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '0';
    signal en_speed    : STD_LOGIC := '0';
    signal en_mux      : STD_LOGIC := '0';
    signal x_pos_i     : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal y_pos_i     : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal lenght      : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal x_pos_o     : STD_LOGIC_VECTOR(3 downto 0);
    signal y_pos_o     : STD_LOGIC_VECTOR(2 downto 0);
    signal bite_itself : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut : tail
        port map (
            clk         => clk,
            rst         => rst,
            en_speed    => en_speed,
            en_mux      => en_mux,
            x_pos_i     => x_pos_i,
            y_pos_i     => y_pos_i,
            lenght      => lenght,
            x_pos_o     => x_pos_o,
            y_pos_o     => y_pos_o,
            bite_itself => bite_itself
        );

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    p_clk : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    p_stim : process
    begin
        ----------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------
        report "RESET start";

        rst      <= '1';
        en_speed <= '0';
        en_mux   <= '0';
        lenght   <= std_logic_vector(to_unsigned(1, 6));
        x_pos_i  <= "0001"; -- 1
        y_pos_i  <= "000";  -- 0

        wait for 30 ns;

        rst <= '0';
        wait for 20 ns;

        ----------------------------------------------------------------
        -- Check initial point after reset
        -- Expected: only head point (1,0)
        ----------------------------------------------------------------
        report "Check initial point";

        assert x_pos_o = "0001" and y_pos_o = "000"
            report "Initial point after reset is wrong"
            severity error;

        ----------------------------------------------------------------
        -- Move 1: new head = (2,0), length = 2
        -- Expected body:
        -- (2,0), (1,0)
        ----------------------------------------------------------------
        report "Move snake to (2,0), length=2";

        lenght  <= std_logic_vector(to_unsigned(2, 6));
        x_pos_i <= "0010"; -- 2
        y_pos_i <= "000";  -- 0

        en_speed <= '1';
        wait for CLK_PERIOD;
        en_speed <= '0';
        wait for CLK_PERIOD;

        assert bite_itself = '0'
            report "Unexpected bite_itself after move 1"
            severity error;

        -- mux -> point 0
        assert x_pos_o = "0001" and y_pos_o = "000"
            report "Unexpected mux state before scan after move 1"
            severity warning;

        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;
        assert x_pos_o = "0010" and y_pos_o = "000"
            report "Body point 0 after move 1 is wrong"
            severity error;

        -- mux -> point 1
        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;

        assert x_pos_o = "0001" and y_pos_o = "000"
            report "Body point 1 after move 1 is wrong"
            severity error;

        ----------------------------------------------------------------
        -- Move 2: new head = (2,1), length = 3
        -- Expected body:
        -- (2,1), (2,0), (1,0)
        ----------------------------------------------------------------
        report "Move snake to (2,1), length=3";

        lenght  <= std_logic_vector(to_unsigned(3, 6));
        x_pos_i <= "0010"; -- 2
        y_pos_i <= "001";  -- 1

        en_speed <= '1';
        wait for CLK_PERIOD;
        en_speed <= '0';
        wait for CLK_PERIOD;

        assert bite_itself = '0'
            report "Unexpected bite_itself after move 2"
            severity error;

        -- mux scan
        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;
        assert x_pos_o = "0010" and y_pos_o = "001"
            report "Body point 0 after move 2 is wrong"
            severity error;

        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;
        assert x_pos_o = "0010" and y_pos_o = "000"
            report "Body point 1 after move 2 is wrong"
            severity error;

        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;
        assert x_pos_o = "0001" and y_pos_o = "000"
            report "Body point 2 after move 2 is wrong"
            severity error;

        ----------------------------------------------------------------
        -- Move 3: new head = (1,1), length = 4
        -- Expected body:
        -- (1,1), (2,1), (2,0), (1,0)
        ----------------------------------------------------------------
        report "Move snake to (1,1), length=4";

        lenght  <= std_logic_vector(to_unsigned(4, 6));
        x_pos_i <= "0001"; -- 1
        y_pos_i <= "001";  -- 1

        en_speed <= '1';
        wait for CLK_PERIOD;
        en_speed <= '0';
        wait for CLK_PERIOD;

        assert bite_itself = '0'
            report "Unexpected bite_itself after move 3"
            severity error;

        -- mux scan
        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;
        assert x_pos_o = "0001" and y_pos_o = "001"
            report "Body point 0 after move 3 is wrong"
            severity error;

        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;
        assert x_pos_o = "0010" and y_pos_o = "001"
            report "Body point 1 after move 3 is wrong"
            severity error;

        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;
        assert x_pos_o = "0010" and y_pos_o = "000"
            report "Body point 2 after move 3 is wrong"
            severity error;

        en_mux <= '1';
        wait for CLK_PERIOD;
        en_mux <= '0';
        wait for CLK_PERIOD;
        assert x_pos_o = "0001" and y_pos_o = "000"
            report "Body point 3 after move 3 is wrong"
            severity error;

        ----------------------------------------------------------------
        -- Self-collision:
        -- new head goes to (2,0), which already exists in active body
        ----------------------------------------------------------------
        report "Check self-collision";

        x_pos_i <= "0010"; -- 2
        y_pos_i <= "000";  -- 0

        en_speed <= '1';
        wait for CLK_PERIOD;
        en_speed <= '0';
        wait for CLK_PERIOD;

        assert bite_itself = '1'
            report "ERROR: bite_itself was not asserted"
            severity error;

        report "tail_tb finished successfully";
        wait;
    end process;
    end Behavioral;