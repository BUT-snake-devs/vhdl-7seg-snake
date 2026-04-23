library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------
entity game_state_led is
    Port ( clk          : in STD_LOGIC;
           rst          : in STD_LOGIC;
           game_state_i : in STD_LOGIC;  -- Input signal indicating if the snake is alive (1) or dead (0)
           led17_g      : out STD_LOGIC;
           led16_r      : out STD_LOGIC
           );
end game_state_led;
---------------------------------------------------------
architecture Behavioral of game_state_led is
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                led17_g <= '0';  -- Turn off green LED on reset
                led16_r <= '0';  -- Turn off red LED on reset
            else
                if game_state_i = '1' then
                    led17_g <= '1';  -- Turn on green LED if the snake is alive
                    led16_r <= '0';  -- Turn off red LED if the snake is alive
                elsif game_state_i = '0' then
                    led17_g <= '0';  -- Turn off green LED if the snake is dead
                    led16_r <= '1';  -- Turn on red LED if the snake is dead
                else
                    null;
                end if;
            end if;
        end if;
    end process;

end Behavioral;