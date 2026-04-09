library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------
entity head is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en_speed :in STD_LOGIC;
           bite_itself : in STD_LOGIC;
           btn_press : in STD_LOGIC;
           btn_data : in STD_LOGIC_VECTOR (3 downto 0);
           x_pos : out STD_LOGIC_VECTOR (2 downto 0);
           y_pos : out STD_LOGIC_VECTOR (1 downto 0));
end head;
---------------------------------------------------------
architecture Behavioral of head is

begin


end Behavioral;
