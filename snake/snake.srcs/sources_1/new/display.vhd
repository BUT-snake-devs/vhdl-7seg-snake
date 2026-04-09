library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------
entity display is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           x_pos : in STD_LOGIC_VECTOR (2 downto 0);
           y_pos : in STD_LOGIC_VECTOR (1 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end display;
---------------------------------------------------------
architecture Behavioral of display is

begin


end Behavioral;
