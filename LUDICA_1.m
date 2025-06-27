function plano_inclinado_ui

    fig = figure('Name', 'Plano Inclinado', 'NumberTitle', 'off', ...
                 'Position', [100, 100, 800, 600], ...
                 'CloseRequestFcn', @cerrar_simulacion);


    uicontrol('Style', 'text', 'String', ['1. Plano y Rueda', newline, ...
                                          ], ...
              'HorizontalAlignment', 'left', 'Position', [10, 500, 700, 100], ...
              'FontSize', 12, 'FontWeight', 'bold');
    uicontrol('Style', 'text', 'String', ['En esta animación, se muestra el comportamiento de una rueda rodando sobre un plano que se encuentra pivotado en el centro.',newline, ...
                                          'En esta lúdica animada se debe intentar ubicar la rueda en el centro del plano.', newline, ...
                                          'Nota: Las unidades para las variables de posición y altura están dadas en cm.'], ...
              'HorizontalAlignment', 'left', 'Position', [10, 510, 750, 65], ...
              'FontSize', 10, 'FontName', 'bold');
    

    menu_bar = uimenu(fig, 'Label', 'Simulación');
    uimenu(menu_bar, 'Label', 'Iniciar', 'Callback', @iniciar_simulacion);
    uimenu(menu_bar, 'Label', 'Pausar', 'Callback', @pausar_simulacion);
    uimenu(menu_bar, 'Label', 'Reiniciar', 'Callback', @reiniciar_simulacion);
    uimenu(menu_bar, 'Label', 'Ocultar pelota', 'Callback', @ocultar_pelota);
 
    ax = axes('Parent', fig, 'Position', [0.1, 0.2, 0.6, 0.6]);  
    hold(ax, 'on');
    axis(ax, 'equal');
    xlim(ax, [-20, 20]);
    ylim(ax, [-20, 20]); 

    barra_longitud = 15; 
    plano = plot(ax, [-barra_longitud, barra_longitud], [0, 0], 'k-', 'LineWidth', 2); 
    pelota_radio = 1.5; 
    pelota = plot(ax, -14, calcular_altura_pelota(-10, 0, pelota_radio), 'o', ...
                  'MarkerSize', 15, 'MarkerFaceColor', [0.5, 0.5, 0.5]); 
    centro = plot(ax, 0, 0, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

    inclinacion = 0; 
    pos_pelota = [-14, calcular_altura_pelota(-10, 0, pelota_radio)];
    velocidad = [0, 0]; 
    pelota_oculta = false;
    tiempo_transcurrido = 0; 

    animacion = timer('ExecutionMode', 'fixedRate', 'Period', 0.05, ...
                      'TimerFcn', @actualizar_simulacion);

    tab_group = uitabgroup('Parent', fig, 'Position', [0.65, 0.16 0.3, 0.6]);

    tab_funcionamiento = uitab('Parent', tab_group, 'Title', 'Funcionamiento');
    uicontrol('Parent', tab_funcionamiento, 'Style', 'text', ...
              'String', ['• Con el botón "▶/❚❚" se inicia o pone en pausa el desplazamiento de la rueda a lo largo del plano.', ...
                         newline, ...
                         newline, ...
                         '• Con el botón "↻" se comienza de nuevo la animación.', ...
                         newline, ...
                         '• Con la barra de deslizamiento vertical se varía la altura "h" del extremo del plano.', ...
                         newline, ...
                         '• Con el botón "Ocultar" se oculta la rueda, mientras que con el botón "Visible" aparece de nuevo la rueda.'], ...
              'HorizontalAlignment', 'left', ...
              'Position', [10, 10, 215, 300] ,...
              'FontSize', 8, 'FontName', 'bold');

    tab_actividades = uitab('Parent', tab_group, 'Title', 'Actividades');
    uicontrol('Parent', tab_actividades, 'Style', 'text', ...
              'String', ['• 1. Con el plano en el extremo más alto, ejecute la animación y observe el desplazamiento de la rueda a lo largo del plano.                                                           ', ... 
                         '• 2. Repita el paso anterior para diferentes grados de inclinación del plano.                   ', ...
                         '• 3. Manipulando la altura del extremo del plano, busque ubicar la rueda en el centro. Repita el procedimiento, tantas veces como sea necesario,', ...
                         'hasta que memorice la acción realizada sobre la inclinación del plano (h ó θ, en función del tiempo). Tome nota del error final de la rueda con respecto al centro.                                                        ', ...
                         '• 4. Reinicie la animación, active el botón "Oculto", ejecute la animación y aplique la acción sobre el plano memorizada en el paso 3. ', ...
                         'Active el botón "Visible" y tome nota del error final de la rueda con respecto al centro.'], ...
              'HorizontalAlignment', 'left', ...
              'Position', [10, 10, 215, 300] ,...
              'FontSize', 8, 'FontName', 'bold');

    tab_discusion = uitab('Parent', tab_group, 'Title', 'Discusión');
    uicontrol('Parent', tab_discusion, 'Style', 'text', ...
              'String', ['• ¿Cuál es la planta?', newline, ...
                     '• ¿Cuáles son la entrada y la salida? ¿La planta es estable?', newline, ...
                     newline, ...
                     '• Obtenga un diagrama de bloques que represente a este sistema de control.', newline, ...
                     newline, ...
                     '• ¿Cómo se comparan los errores en los pasos 3 y 4?', newline, ...
                     newline, ...
                     '• ¿Qué puede concluir acerca del comportamiento del sistema?'], ...
              'HorizontalAlignment', 'left', ...
              'Position', [10, 10, 215, 300] ,...
              'FontSize', 8, 'FontName', 'bold');

    uicontrol('Style', 'text', 'String', 'Altura (h):', ...
              'Position', [10, 260, 120, 20]);
    slider_altura = uicontrol('Style', 'slider', 'Min', -15, 'Max', 15, ...
                              'Value', 0, 'Position', [50, 60, 30, 200], ...
                              'Callback', @cambiar_altura);
    
    uicontrol('Style', 'text', 'String', 'Ángulo (°):', ...
              'Position', [120, 60, 70, 20]);
    caja_angulo = uicontrol('Style', 'edit', 'String', '0', ...
                            'Position', [120, 40, 70, 20], ...
                            'Callback', @cambiar_angulo);
    uicontrol('Style', 'text', 'String', 'Tiempo (s):', ...
              'Position', [630, 60, 70, 20]);
    tiempo_label = uicontrol('Style', 'edit', 'String', '0', ...
                            'Position', [630, 40, 70, 20], ...
                            'Callback', @cambiar_angulo);
    
    boton_iniciar = uicontrol('Style', 'pushbutton', 'String', '▶', ...
                              'Position', [220, 50, 70, 30], ...
                              'Callback', @iniciar_simulacion);
    boton_pausar = uicontrol('Style', 'pushbutton', 'String', '❚❚', ...
                             'Position', [320, 50, 70, 30], ...
                             'Callback', @pausar_simulacion);
    boton_reiniciar = uicontrol('Style', 'pushbutton', 'String', '↻', ...
                                'Position', [420, 50, 70, 30], ...
                                'Callback', @reiniciar_simulacion);
    boton_ocultar = uicontrol('Style', 'pushbutton', 'String', 'Ocultar', ...
                              'Position', [520, 50, 70, 30], ...
                              'Callback', @ocultar_pelota);
     
    pelota_label = text(ax, pos_pelota(1), pos_pelota(2) + 2, ...
                        sprintf('Pos=%.2f', pos_pelota(1)), ...
                        'HorizontalAlignment', 'center', ...
                        'FontSize', 10, 'FontWeight', 'bold', ...
                        'Color', 'black');
       
    base_x = [-5, 0, 5]; 
    base_y = [-20, 0, -20]; 
    fill(ax, base_x, base_y, [0.3, 0.3, 0.3], 'EdgeColor', 'none'); 


    function cambiar_altura(~, ~)
        altura = get(slider_altura, 'Value');
        inclinacion =-1*atan(altura / barra_longitud) * (180 / pi);
        inclinacion_1 =atan(altura / barra_longitud) * (180 / pi);
        set(caja_angulo, 'String', num2str(inclinacion_1));
        actualizar_plano();
        actualizar_pelota(); 
    end

    function cambiar_angulo(~, ~)
        inclinacion = str2double(get(caja_angulo, 'String'));
        altura = tand(inclinacion) * barra_longitud;
        set(slider_altura, 'Value', altura);
        actualizar_plano();
        actualizar_pelota(); 
    end

    function actualizar_plano()
        x_inicio = -barra_longitud;
        x_fin = barra_longitud;
        y_inicio = calcular_altura_pelota(x_inicio, inclinacion, 0);
        y_fin = calcular_altura_pelota(x_fin, inclinacion, 0);
        set(plano, 'XData', [x_inicio, x_fin], 'YData', [y_inicio, y_fin]);
    end

    function actualizar_pelota()
        pos_pelota(2) = calcular_altura_pelota(pos_pelota(1), inclinacion, pelota_radio);
        set(pelota, 'XData', pos_pelota(1), 'YData', pos_pelota(2));
        
        set(pelota_label, 'Position', [pos_pelota(1), pos_pelota(2) + 2], ...
                          'String', sprintf('Pos=%.2f', pos_pelota(1)));
    end

    function actualizar_simulacion(~, ~)
        tiempo_transcurrido = tiempo_transcurrido + 0.05;  
        set(tiempo_label, 'String', sprintf(' %.2f ', tiempo_transcurrido));
        [pos_pelota, velocidad] = mover_pelota(pos_pelota, velocidad, inclinacion);
        set(pelota, 'XData', pos_pelota(1), 'YData', pos_pelota(2));

        set(pelota_label, 'Position', [pos_pelota(1), pos_pelota(2) + 2], ...
                          'String', sprintf('Pos=%.2f', pos_pelota(1)));

        if pos_pelota(1) > barra_longitud || pos_pelota(1) < -barra_longitud
            reiniciar_simulacion();
        end

        if abs(pos_pelota(1)) < 0.1 && norm(velocidad) < 0.1
            stop(animacion);
            msgbox('¡Felicidades! La pelota está en el centro.', 'Objetivo logrado');
        end
    end
  
    function iniciar_simulacion(~, ~)
        if strcmp(animacion.Running, 'off')
            start(animacion);
        end
    end

    function pausar_simulacion(~, ~)
        if strcmp(animacion.Running, 'on')
            stop(animacion);
        end
    end

       function reiniciar_simulacion(~, ~)
        stop(animacion);  
        inclinacion = 0;  
        set(slider_altura, 'Value', 0);  
        set(caja_angulo, 'String', '0'); 
        pos_pelota = [-14, calcular_altura_pelota(-10, 0, pelota_radio)]; 
        velocidad = [0, 0]; 
        set(pelota, 'XData', pos_pelota(1), 'YData', pos_pelota(2), 'Visible', 'on');  
        actualizar_plano(); 
        tiempo_transcurrido = 0;  
        set(tiempo_label, 'String', ' 0.00 ');  
        
        % Reiniciar la posición de la etiqueta
        set(pelota_label, 'Position', [pos_pelota(1), pos_pelota(2) + 2], ...  
                          'String', sprintf('Pos=%.2f', pos_pelota(1))); 
    end


    function ocultar_pelota(~, ~)
        pelota_oculta = ~pelota_oculta;
        if pelota_oculta
            set(pelota, 'Visible', 'off');
        else
            set(pelota, 'Visible', 'on');
        end
    end

    function [pos, vel] = mover_pelota(pos, vel, angulo)
        g = 9.81;
        friccion = 0.98; 
        dt = 0.05;
        a = -g * sind(angulo);

        vel(1) = vel(1) + a * dt;
        vel(1) = vel(1) * friccion;
        pos(1) = pos(1) + vel(1) * dt;

        pos(2) = calcular_altura_pelota(pos(1), angulo, pelota_radio);
    end

    function y = calcular_altura_pelota(x, angulo, radio)
        y = tand(angulo) * x + radio;
    end

    function cerrar_simulacion(~, ~)
        stop(animacion);
        delete(animacion);
        delete(fig);
    end
end