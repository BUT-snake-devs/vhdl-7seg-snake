library ieee;
use ieee.std_logic_1164.all;

entity tb_game_state_led is
end tb_game_state_led;

architecture tb of tb_game_state_led is

    component game_state_led
        port (clk          : in std_logic;
              rst          : in std_logic;
              game_state_i : in std_logic;
              led17_g      : out std_logic;
              led16_r      : out std_logic);
    end component;

    signal clk          : std_logic;
    signal rst          : std_logic;
    signal game_state_i : std_logic;
    signal led17_g      : std_logic;
    signal led16_r      : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : game_state_led
    port map (clk          => clk,
              rst          => rst,
              game_state_i => game_state_i,
              led17_g      => led17_g,
              led16_r      => led16_r);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        report "Starting simulation";
        
        rst <= '1';
        game_state_i <= '0';  -- Start with snake alive
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        report "Test 1: Snake is alive (green LED should be on, red LED should be off)";
        game_state_i <= '0';
        wait for 100 ns;
        
        report "Test 2: Snake is dead (green LED should be off, red LED should be on)";
        game_state_i <= '1';
        wait for 100 ns;

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        report "Resetting";
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        report "Simulation ended";
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_game_state_led of tb_game_state_led is
    for tb
    end for;
end cfg_tb_game_state_led;