library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity symb_det is
    Port (  clk: in STD_LOGIC; -- input clock 96kHz
            clr: in STD_LOGIC; -- input synchronized reset
            adc_data: in STD_LOGIC_VECTOR(11 DOWNTO 0); -- input 12-bit ADC data
            symbol_valid: out STD_LOGIC;
            symbol_out: out STD_LOGIC_VECTOR(2 DOWNTO 0) -- output 3-bit detection symbol
            );
end symb_det;

architecture Behavioral of symb_det is
  signal curr_wave_positive: std_logic := '0';
  signal last_wave_positive: std_logic := '0';
  signal count : integer range 0 to 6000 := 0;
  signal counter_value : integer range 0 to 210 := 0;
  
begin
process(clk, clr, adc_data)
begin
    if (clr = '1') then
      curr_wave_positive <= '0';
      last_wave_positive <= '0';
      count <= 0;
      counter_value <= 0;
      symbol_valid <= '0';
      symbol_out <= "000";
    elsif rising_edge(clk) then
        if count < 6000 then 
          symbol_valid <= '0';
          if adc_data(11) = '0' then 
            curr_wave_positive <= '1';
          elsif adc_data(11) = '1' then
            curr_wave_positive <= '0';
          end if;
          if curr_wave_positive = '0' and last_wave_positive = '1' then
            counter_value <= counter_value + 1;
          end if;
          last_wave_positive <= curr_wave_positive;
          count <= count + 1;
        else
          if ((28 < counter_value) and (counter_value < 141))then
            symbol_valid <= '1';
            if ((120 < counter_value) and (counter_value < 141)) then
              symbol_out <= "111";
            elsif ((98 < counter_value) and (counter_value < 121)) then
              symbol_out <= "110";
            elsif ((80 < counter_value) and (counter_value < 99)) then
              symbol_out <= "101";
            elsif ((67 < counter_value) and (counter_value < 81)) then
              symbol_out <= "100";
            elsif ((55 < counter_value) and (counter_value < 68)) then
              symbol_out <= "011";
            elsif ((45 < counter_value) and (counter_value < 56)) then
              symbol_out <= "010";
            elsif ((37 < counter_value) and (counter_value < 46)) then
              symbol_out <= "001";
            elsif ((28 < counter_value) and (counter_value < 38)) then
              symbol_out <= "000";
            end if;
          else
            symbol_valid <= '0';
          end if;
          count <= 0;
          counter_value <= 0;
      end if;
    end if;
end process;

-- generate enable signals based on 16Hz symbol rate
-- output the detected symbols based on 16 Hz rate
     
end Behavioral;