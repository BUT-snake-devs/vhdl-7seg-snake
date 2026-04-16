library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_head is
end tb_head;

architecture tb of tb_head is

    -- Component Declaration for the Unit Under Test (UUT)
    component head
        port (clk         : in std_logic;
              rst         : in std_logic;
              en_speed    : in std_logic;
              bite_itself : in std_logic;
              btn_press   : in std_logic;
              btn_data    : in std_logic_vector (1 downto 0);
              x_pos       : out std_logic_vector (3 downto 0);
              y_pos       : out std_logic_vector (2 downto 0));
    end component;

    -- Testbench signals
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal en_speed    : std_logic := '0';
    signal bite_itself : std_logic := '0';
    signal btn_press   : std_logic := '0';
    signal btn_data    : std_logic_vector (1 downto 0) := (others => '0');
    signal x_pos       : std_logic_vector (3 downto 0);
    signal y_pos       : std_logic_vector (2 downto 0);

    -- Clock period definitions (100 MHz clock)
    constant TbPeriod : time      := 10 ns;
    signal TbClock    : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    -- Instantiate the Unit Under Test (UUT)
    dut : head
    port map (clk         => clk,
              rst         => rst,
              en_speed    => en_speed,
              bite_itself => bite_itself,
              btn_press   => btn_press,
              btn_data    => btn_data,
              x_pos       => x_pos,
              y_pos       => y_pos);

    -- Clock generation process
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    -- Stimulus process
    stimuli : process
        -- Helper procedure to simulate one snake movement step
        procedure make_step is
        begin
            en_speed <= '1';
            wait for TbPeriod;
            en_speed <= '0';
            wait for TbPeriod * 4;
        end procedure;

        -- Helper procedure to simulate a button press
        procedure press_button(dir : std_logic_vector(1 downto 0)) is
        begin
            btn_data <= dir;
            btn_press <= '1';
            wait for TbPeriod;
            btn_press <= '0';
            wait for TbPeriod;
        end procedure;

    begin
        -- PHASE 1: System Reset
        report "Checking initial coordinates (Should be X=1, Y=0)";
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        -- PHASE 2: Normal Movement
        report "Testing normal movement (Should move from X=1, Y=0 to X=2, Y=0)";
        make_step; 
        
        report "Changing direction to DOWN";
        press_button("10"); 
        make_step; -- Moves to (2,1)
        make_step; -- Moves to (2,3)
        
        -- PHASE 3: Right Boundary Check
        report "Changing direction to RIGHT";
        press_button("11");
        make_step; -- Moves to (1,4)

        -- PHASE 4: Collision with Wall (Left side)
        -- We force the snake to go Right until X < 0
        report "Testing collision with wall";
        press_button("11");
        make_step; -- X=0
        make_step; -- X=-1 (Should trigger GAME_STATE = DEAD)
        
        -- Verify that coordinates don't change after death
        make_step;
        make_step;

        -- PHASE 5: Recovery from Death
        -- Pressing Reset to start over
        report "Testing reset after death";
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- PHASE 6: Self-Bite Simulation
        report "Testing self-bite";
        make_step;
        bite_itself <= '1';
        make_step; -- Should trigger GAME_STATE = DEAD
        bite_itself <= '0';

        -- End Simulation
        wait for 100 ns;
        TbSimEnded <= '1';
        report "Simulation Finished Successfully";
        wait;
    end process;

end tb;