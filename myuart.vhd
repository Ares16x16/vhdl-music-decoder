library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity myuart is
    Port (
        din : in STD_LOGIC_VECTOR (7 downto 0);
        busy: out STD_LOGIC;
        wen : in STD_LOGIC;
        sout : out STD_LOGIC;
        clr : in STD_LOGIC;
        clk : in STD_LOGIC);
end myuart;

architecture rtl of myuart is
    type state_type is (S_IDLE, S_STARTBIT, S_D0, S_D1, S_D2, S_D3, S_D4, S_D5, S_D6, S_D7, S_STOPBIT, IDLE);
    signal state, next_state : state_type := S_IDLE ;
    --signals for baud rate
    --96k/9600 == 10 (for every 10 clk cycle 1 bit of data is transfered
    signal count : integer range 0 to 9 := 0;

begin
    --reset state: S_IDLE
    SYNC_PROC :process (clk)
    begin
        if (clr = '1') then
            state <= S_IDLE;
        elsif rising_edge (clk) then
            state <= next_state;
        end if;
    end process;

    NEXT_STATE_DECODE  : process (count)
    begin
        next_state <= state;
        case (state) is
            when S_IDLE =>
                --if wen detected
                if (wen = '1') then
                    next_state <= S_STARTBIT;
                end if;

            when S_STARTBIT =>
                --if count reached 9, goto next state, similar for all state expect IDLE and S_IDLE
                if (count >= 9) then
                    next_state <= S_D0;
                end if;

            when S_D0  =>
                if (count >= 9) then
                    next_state <= S_D1;
                end if;

            when S_D1  =>
                if (count >= 9) then
                    next_state <= S_D2;
                end if;

            when S_D2  =>
                if (count >= 9) then
                    next_state <= S_D3;
                end if;

            when S_D3  =>
                if (count >= 9) then
                    next_state <= S_D4;
                end if;

            when S_D4  =>
                if (count >= 9) then
                    next_state <= S_D5;
                end if;

            when S_D5 =>
                if (count >= 9) then
                    next_state <= S_D6;
                end if;

            when S_D6 =>
                if (count >= 9) then
                    next_state <= S_D7;
                end if;

            when S_D7  =>
                if (count >= 9) then
                    next_state <= S_STOPBIT ;
                end if;

            when S_STOPBIT =>
                if count >= 9 then
                    next_state <= IDLE;
                end if;
                
            when IDLE =>
                next_state <= S_IDLE;

        end case;
    end process;

    OUTPUT_DECODE : process(state)
    begin
    --configure the output of busy and sout accordingly
        if (state = s_idle) then
            busy <= '0';
            sout <= '1';

        elsif (state = S_STARTBIT) then
            busy <= '1';
            sout <= '0';

    --output the corresponding bit of din directly 
        elsif (state = S_D0) then
            busy <= '1';
            sout <= din(0);

        elsif (state = S_D1) then
            busy <= '1';
            sout <= din(1);

        elsif (state = S_D2) then
            busy <= '1';
            sout <= din(2);

        elsif (state = S_D3) then
            busy <= '1';
            sout <= din(3);

        elsif (state = S_D4) then
            busy <= '1';
            sout <= din(4);

        elsif (state = S_D5) then
            busy <= '1';
            sout <= din(5);

        elsif (state = S_D6) then
            busy <= '1';
            sout <= din(6);

        elsif (state = S_D7) then
            busy <= '1';
            sout <= din(7);

        elsif(state = S_STOPBIT) then
            busy <= '1';
            sout <= '1';

        elsif (state = IDLE) then
            busy <= '0';
            sout <= '1';
        end if;

    end process;
    -- Generate 9600 Baud based on 96k clock (1:10)
    --counts 10 clk cycles and reset itself (as 10 clk cycle = 1 baud)
    PROC_BAUD_GEN: process(clk)
    begin
        if (rising_edge (clk)) then
            if count < 9 then
                count <= count + 1;
            else
                count <= 0;
            end if;
        end if;
    end process;
end rtl;
