function h = sigmoid(z)
   h =  1 ./ (1 + exp(1) .^ (-z));
end