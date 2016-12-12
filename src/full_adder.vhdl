entity FULL_ADDER is
    port(A : in bit;
        B : in bit;
        Cin : in bit;
        S : out bit;
        Cout : out bit);
end entity;

architecture FULL_ADDER_arch of FULL_ADDER is
begin
    S <= A xor B xor Cin;
    Cout <= (A and B) or (B and Cin) or (Cin and A);
end architecture;
