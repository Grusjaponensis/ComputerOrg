module VotingMachine(
    input A,
    input B,
    input C,
    output Y
);
    assign Y = (A & B) + (B & C) + (A & C);
endmodule //VotingMachine
