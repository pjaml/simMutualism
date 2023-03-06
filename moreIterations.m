function newIterations = moreIterations(speedP, speedF1, speedF2, generation, iterations, iterationStep, maxIterations, steadyStateThreshold)

            % extend the sizes of the relevant vectors & matrices
            [instantSpeedP(length(instantSpeedP)+1:iterations), avgSpeedP(length(avgSpeedP)+1:iterations), instantSpeedF1(length(instantSpeedF1)+1:iterations), avgSpeedF1(length(avgSpeedF1)+1:iterations), instantSpeedF2(length(instantSpeedF2)+1:iterations), avgSpeedF2(length(avgSpeedF2)+1:iterations)] = deal(0);
            [rangeEdgeP(length(rangeEdgeP)+1:iterations+1),rangeEdgeF1(length(rangeEdgeF1)+1:iterations+1), rangeEdgeF2(length(rangeEdgeF2)+1:iterations+1)] = deal(0);

            [nP(height(nP)+1:iterations+1,:), nF1(height(nF1)+1:iterations+1,:), nF2(height(nF2)+1:iterations+1,:)] = deal(zeros((iterations+1)-height(nP), length(nP)));
        else
            break
        end
    end
end
