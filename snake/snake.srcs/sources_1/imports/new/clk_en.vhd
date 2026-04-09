library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------
entity clk_en is
    generic (
        G_MAX : positive := 25_000_000  -- Default number of clock cycles
    );
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ce  : out STD_LOGIC);
end clk_en;
-------------------------------------------
architecture Behavioral of clk_en is
    signal s_cnt : integer range 0 to G_MAX-1;
begin

    -- Count clock pulses and generate a one-clock-cycle enable pulse
    process (clk) is
    begin
        if rising_edge(clk) then  -- Synchronous process
            if rst = '1' then     -- High-active reset
                ce    <= '0';   -- Reset output
                s_cnt <= 0;     -- Reset internal counter

            elsif s_cnt = G_MAX-1 then
                -- TODO: Set output pulse and reset internal counter
                ce    <= '1';
                s_cnt <= 0;
            else
                -- TODO: Clear output and increment internal counter
                ce    <= '0';
                s_cnt <= s_cnt+1;
            end if;  -- End if for reset/check
        end if;      -- End if for rising_edge
    end process;
end Behavioral;
