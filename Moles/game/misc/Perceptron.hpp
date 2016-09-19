//
//  Perceptron.hpp
//  Moles
//
//  Created by William Izzo on 10/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#ifndef Perceptron_hpp
#define Perceptron_hpp

#include <stdio.h>

namespace molegame {
namespace misc {

    template<int Pc>
    struct Params {
        int p[Pc];
    };
    
    template<int Ic>
    class Perceptron {
    public:
        void init(Params<Ic> weights, int treshold) {
            for (int wIdx = 0; wIdx < Ic; ++wIdx) {
                this->weights.p[wIdx] = weights.p[wIdx];
            }
            
            this->treshold = treshold;
        };
        
        bool output(Params<Ic> inputs) {
            int sum = 0;
            for (int inIdx = 0; inIdx < Ic; ++inIdx) {
                sum+= inputs.p[inIdx] * this->weights.p[inIdx];
            }
            
            return sum > this->treshold;
        }
    private:
        Params<Ic> weights;
        int treshold;
        
    };
    
};
};

#endif /* Perceptron_hpp */
