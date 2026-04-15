library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------
entity btn_ctrl is
    Port ( clk       : in STD_LOGIC;
           rst       : in STD_LOGIC;
           btnu      : in STD_LOGIC;
           btnl      : in STD_LOGIC;
           btnd      : in STD_LOGIC;
           btnr      : in STD_LOGIC;
           btn_press : out STD_LOGIC;
           btn_data  : out STD_LOGIC_VECTOR (1 downto 0));
end btn_ctrl;
---------------------------------------------------------
architecture Behavioral of btn_ctrl is
    signal btn_state_prev : std_logic_vector(3 downto 0) := "0000";
    signal btn_state_curr : std_logic_vector(3 downto 0) := "0000";
    signal btn_diff       : std_logic_vector(3 downto 0);
begin
    btn_diff <= btn_state_curr and not btn_state_prev;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                btn_state_prev <= "0000";
                btn_state_curr <= "0000";
                btn_press      <= '0';
                btn_data       <= "00";
            else
                btn_state_curr <= btnu & btnr & btnd & btnl;
                btn_state_prev <= btn_state_curr;
                btn_press <= '0';
                case btn_diff is
                    when "1000" => btn_press <= '1'; btn_data <= "00"; -- UP
                    when "0100" => btn_press <= '1'; btn_data <= "01"; -- RIGHT
                    when "0010" => btn_press <= '1'; btn_data <= "10"; -- DOWN
                    when "0001" => btn_press <= '1'; btn_data <= "11"; -- LEFT
                    when others => null; 
                end case;
            end if;
        end if;
    end process;
end Behavioral;
