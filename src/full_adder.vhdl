entity FULL_ADDER is
    port(A,B,CARRY_IN:in bit;
         S,CARRY_OUT:out bit);
end entity;

architecture FULL_ADDER_arch of FULL_ADDER is
begin
    S <= A xor B xor CARRY_IN;
    CARRY_OUT <= (A and B) or (B and CARRY_IN) or (CARRY_IN and A);
end architecture;
