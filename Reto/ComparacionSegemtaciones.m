% Cargar las dos segmentaciones realizadas con FreeSurfer
seg1 = MRIread('segmentacion1.mgz');
seg2 = MRIread('segmentacion2.mgz');

% Obtener la matriz de confusión
confusionMatrix = zeros(2, 2);
confusionMatrix(1, 1) = sum(seg1.vol == 1 & seg2.vol == 1);
confusionMatrix(1, 2) = sum(seg1.vol == 1 & seg2.vol == 0);
confusionMatrix(2, 1) = sum(seg1.vol == 0 & seg2.vol == 1);
confusionMatrix(2, 2) = sum(seg1.vol == 0 & seg2.vol == 0);

% Calcular las métricas de evaluación
accuracy = (confusionMatrix(1, 1) + confusionMatrix(2, 2)) / sum(confusionMatrix(:));
precision = confusionMatrix(1, 1) / (confusionMatrix(1, 1) + confusionMatrix(1, 2));
sensitivity = confusionMatrix(1, 1) / (confusionMatrix(1, 1) + confusionMatrix(2, 1));
specificity = confusionMatrix(2, 2) / (confusionMatrix(2, 2) + confusionMatrix(1, 2));
jaccard = confusionMatrix(1, 1) / (confusionMatrix(1, 1) + confusionMatrix(1, 2) + confusionMatrix(2, 1));
dice = 2 * confusionMatrix(1, 1) / (2 * confusionMatrix(1, 1) + confusionMatrix(1, 2) + confusionMatrix(2, 1));
overlap = confusionMatrix(1, 1) / (confusionMatrix(1, 1) + min(confusionMatrix(1, 2), confusionMatrix(2, 1)));
kappa = (accuracy - sum(sum(confusionMatrix))*sum(sum(confusionMatrix(:, :)))/(sum(sum(confusionMatrix(1, :)))*sum(sum(confusionMatrix(:, 1)))))/(1 - sum(sum(confusionMatrix))*sum(sum(confusionMatrix(:, :)))/(sum(sum(confusionMatrix(1, :)))*sum(sum(confusionMatrix(:, 1)))));

% Mostrar los resultados en pantalla
disp(['Exactitud: ', num2str(accuracy)]);
disp(['Precisión: ', num2str(precision)]);
disp(['Sensibilidad: ', num2str(sensitivity)]);
disp(['Especificidad: ', num2str(specificity)]);
disp(['Coeficiente de Jaccard: ', num2str(jaccard)]);
disp(['Similarity Dice: ', num2str(dice)]);
disp(['Overlap measure: ', num2str(overlap)]);
disp(['Kappa: ', num2str(kappa)]);
