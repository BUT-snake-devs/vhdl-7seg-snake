library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------
entity tail is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en_mux : in STD_LOGIC;
           en_speed :in STD_LOGIC;
           x_pos_i : in STD_LOGIC_VECTOR (2 downto 0);
           y_pos_i : in STD_LOGIC_VECTOR (1 downto 0);
           lenght : in STD_LOGIC_VECTOR (5 downto 0);
           x_pos_o : out STD_LOGIC_VECTOR (2 downto 0);
           y_pos_o : out STD_LOGIC_VECTOR (1 downto 0);
           bite_itself : out STD_LOGIC);
end tail;
---------------------------------------------------------
architecture Behavioral of tail is

begin


end Behavioral;
