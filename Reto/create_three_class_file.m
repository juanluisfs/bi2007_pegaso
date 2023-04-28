function create_three_class_file(input_file, output_file)
    % Leer los datos del archivo de etiquetas usando la función read_label de FreeSurfer
    [~, labels, colormap] = read_label(input_file);
    
    % Crear una matriz con etiquetas de tres clases: Materia Gris, Materia Blanca y Otros
    three_class_labels = zeros(size(labels));
    gray_matter_indices = colormap.table(:,5) == 3 | colormap.table(:,5) == 42 | colormap.table(:,5) == 8 | colormap.table(:,5) == 47;
    white_matter_indices = colormap.table(:,5) == 2 | colormap.table(:,5) == 7 | colormap.table(:,5) == 16 | colormap.table(:,5) == 28 | colormap.table(:,5) == 46;
    three_class_labels(gray_matter_indices) = 1;
    three_class_labels(white_matter_indices) = 2;
    three_class_labels(~(gray_matter_indices | white_matter_indices)) = 3;
    
    % Escribir los datos de etiquetas de tres clases en el archivo de salida
    write_label(three_class_labels, output_file);
end

% create_three_class_file('segmentation.label', 'segmentation_3class.label');