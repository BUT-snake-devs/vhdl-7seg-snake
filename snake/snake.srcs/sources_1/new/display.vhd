library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------
entity display is
    Port ( clk    : in STD_LOGIC;
           rst    : in STD_LOGIC;
           x_pos  : in STD_LOGIC_VECTOR (3 downto 0);
           y_pos  : in STD_LOGIC_VECTOR (2 downto 0);
           an     : out STD_LOGIC_VECTOR (7 downto 0);
           seg    : out STD_LOGIC_VECTOR (6 downto 0));
end display;
---------------------------------------------------------
architecture Behavioral of display is

    signal x_pos_int : integer;
    signal y_pos_int : integer;

begin

    x_pos_int <= to_integer(unsigned(x_pos)); -- Convert x_pos from std_logic_vector to integer
    y_pos_int <= to_integer(unsigned(y_pos)); -- Convert y_pos from std_logic_vector to integer

    -- Display logic to convert x_pos and y_pos to 7-segment encoding
    decoder : process (clk)
    begin
        if rising_edge(clk) then
            -- This is a placeholder for the actual display logic
            an  <= (others => '1');  -- Default anode state
            seg <= (others => '1');  -- Default segment state

            if rst = '1' then
                null; -- Reset display logic if needed
            else

                if x_pos_int = 0 or x_pos_int = 1 then
                    an(0) <= '0'; -- Example: Turn on anode 0 for certain x positions
                else
                    an(x_pos_int - 1) <= '0'; -- Turn off anode for other positions
                end if;

                if x_pos_int = 0 then
                    case y_pos_int is
                        when 1 => seg(5) <= '0'; -- B
                        when 3 => seg(4) <= '0'; -- C
                        when others => null;
                    end case;
                else
                    case y_pos_int is
                        when 0 => seg(6) <= '0'; -- A
                        when 1 => seg(1) <= '0'; -- F
                        when 2 => seg(0) <= '0'; -- G
                        when 3 => seg(2) <= '0'; -- E
                        when 4 => seg(3) <= '0'; -- D
                        when others => null;
                    end case;
                end if;

            end if;
        end if;
    end process decoder;

end Behavioral;
