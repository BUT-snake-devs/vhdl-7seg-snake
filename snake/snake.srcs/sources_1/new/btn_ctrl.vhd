library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------
entity btn_ctrl is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnr : in STD_LOGIC;
           btn_press : out STD_LOGIC;
           btn_data : out STD_LOGIC_VECTOR (3 downto 0));
end btn_ctrl;
---------------------------------------------------------
architecture Behavioral of btn_ctrl is

begin


end Behavioral;
