library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------
entity head is
    Generic (
        MAX_X : integer := 7;  -- Maximum X position (for display)
        MAX_Y : integer := 4   -- Maximum Y position (for display)
    );
    Port ( clk         : in STD_LOGIC;
           rst         : in STD_LOGIC;
           en_speed    : in STD_LOGIC;
           bite_itself : in STD_LOGIC;
           btn_press   : in STD_LOGIC;
           btn_data    : in STD_LOGIC_VECTOR (1 downto 0);
           x_pos       : out STD_LOGIC_VECTOR (2 downto 0);
           y_pos       : out STD_LOGIC_VECTOR (2 downto 0));
end head;
---------------------------------------------------------
architecture Behavioral of head is

    type direction_type is (UP, DOWN, LEFT, RIGHT);
    type game_state_type is (ALIVE, DEAD);

    signal current_direction : direction_type := LEFT;  -- Initial direction of the snake
    signal new_direction     : direction_type;
    signal intent_direction  : direction_type := LEFT;  -- Initial intent direction
    signal game_state        : game_state_type := ALIVE;  -- Initial game state

    signal x_pos_int : integer := 0;  -- Initial X position of the snake
    signal y_pos_int : integer := 0;  -- Initial Y position of the snake

begin

    with btn_data select
        new_direction <= UP    when "00",
                         LEFT  when "01",
                         DOWN  when "10",
                         RIGHT when "11",
                         current_direction when others;

    change_direction : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                intent_direction <= LEFT;  -- Reset intent direction on reset
            elsif btn_press = '1' then
                if (current_direction = UP and new_direction /= DOWN) or
                   (current_direction = DOWN and new_direction /= UP) or
                   (current_direction = LEFT and new_direction /= RIGHT) or
                   (current_direction = RIGHT and new_direction /= LEFT) then
                    intent_direction <= new_direction;  -- Update direction on button press
                end if;
            end if;
        end if;
    end process change_direction;

    new_state : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_direction <= LEFT;       -- Default direction on reset
                new_direction     <= LEFT;       -- Default new direction on reset
                game_state        <= ALIVE;      -- Reset game state to ALIVE
                x_pos_int         <= 0;          -- Reset X position to 0
                y_pos_int         <= 0;          -- Reset Y position to 0
            elsif en_speed = '1' then
                if game_state = ALIVE then
                        case y_pos_int is
                            when 1 or 3 =>
                                case current_direction is
                                    when UP    =>
                                        if intent_direction = UP then
                                            y_pos_int <= y_pos_int - 2;
                                        elsif intent_direction = LEFT then
                                            x_pos_int <= x_pos_int + 1;
                                            y_pos_int <= y_pos_int - 1;
                                            current_direction <= LEFT;
                                        elsif intent_direction = RIGHT then
                                            y_pos_int <= y_pos_int - 1;
                                            current_direction <= RIGHT;
                                        else
                                            null;
                                        end if;

                                    when DOWN  => 
                                        if intent_direction = DOWN then
                                            y_pos_int <= y_pos_int + 2;
                                        elsif intent_direction = LEFT then
                                            x_pos_int <= x_pos_int + 1;
                                            y_pos_int <= y_pos_int + 1;
                                            current_direction <= LEFT;
                                        elsif intent_direction = RIGHT then
                                            y_pos_int <= y_pos_int + 1;
                                            current_direction <= RIGHT;
                                        else
                                            null;
                                        end if;

                                    when others => null;
                                end case;

                            when 0 or 2 or 4 =>
                                case current_direction is
                                    when LEFT  =>
                                        if intent_direction = LEFT then
                                            x_pos_int <= x_pos_int + 1;
                                        elsif intent_direction = UP then
                                            y_pos_int <= y_pos_int - 1;
                                            current_direction <= UP;
                                        elsif intent_direction = DOWN then
                                            y_pos_int <= y_pos_int + 1;
                                            current_direction <= DOWN;
                                        else
                                            null;
                                        end if;

                                    when RIGHT =>
                                        x_pos_int <= x_pos_int - 1;

                                        if intent_direction = UP then
                                            y_pos_int <= y_pos_int - 1;
                                            current_direction <= UP;
                                        elsif intent_direction = DOWN then
                                            y_pos_int <= y_pos_int + 1;
                                            current_direction <= DOWN;
                                        else
                                            null;
                                        end if;

                                    when others => null;
                                end case;

                            when others => null;
                        end case;

                    if x_pos_int < 0 or x_pos_int > MAX_X or 
                        y_pos_int < 0 or y_pos_int > MAX_Y or bite_itself = '1' then
                        
                        game_state <= DEAD; -- Set game state to DEAD if the snake goes out of bounds or bites itself
                    end if;
                else
                    null;  -- No movement if the snake is dead
                end if;
            end if;
        end if;
    end process new_state;

    output_logic : process (clk)
    begin
        if rising_edge(clk) then
            x_pos <= std_logic_vector(to_unsigned(x_pos_int, 3));  -- Convert integer to 3-bit vector
            y_pos <= std_logic_vector(to_unsigned(y_pos_int, 3));  -- Convert integer to 3-bit vector
        end if;
    end process output_logic;

end Behavioral;
