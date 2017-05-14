# ProjectZ
Attempt to implement MultiLayer Perceptron in hardware descriptive language like VHDL.
![MLP](https://upload.wikimedia.org/wikipedia/commons/6/60/ArtificialNeuronModel_english.png)

### Reason for hardware level implementation
- Increases Efficiency
- High level of parallelism and piplining 
- Implementation cost is low

### Idea
![Implementation Idea](http://i.imgur.com/HFaVwVg.png)
- **Inputs**: n-parallel signal cables
- **Output**: m-parallel signal cables
- **SRAM**: To store weights
- **Multiplier/Adder**: To evaluate weighted sum
- **Buffer**: Because multiplication would be parallel, but for adding weighted sums we need to maintain previous sum every time which works likes a left-over sum or carry sum for next calculation.
- **Activation Function**: MLP Activation Function.

### License
- Aastha Gupta
- Aman Priyadarshi
