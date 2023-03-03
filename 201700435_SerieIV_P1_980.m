if (exist('OCTAVE_VERSION','builtin')~=0)
  pkg load signal;
 end
 
 % Menu Principal
 opcion = 0;
 while opcion ~= 5
   %opcion = input('Seleccione una opcion: \n 1. Grabar audio\n 2. Reproducir Audio\n 3. Graficar audio\n 4. Salir\n');
   % Menu Opciones
  disp('Seleccione una opcion:')
  disp('1. Grabar')
  disp('2. Reproducir')
  disp('3. Graficar')
  disp('4. Graficar densidad')
  disp('5. Salir')
  opcion = input('Ingrese su Eleccion:');
    switch opcion
      case 1
      %grabacion de audio
        try
          duracion = input('Ingrese la duracion de la grabacion en segundos:')
          disp('Comenzando la grabacion...');
          recObj = audiorecorder;
          recordblocking(recObj,duracion);
          disp('Grabacion Finalizada')
          data = getaudiodata(recObj);
          audiowrite('audio.wav', data, recObj.SampleRate);
         disp('Archivo de audio grabado correctamente.');
        
        catch
          disp('Error al grabar el Audio');
        end
      case 2
        % Reproduccion de audio
        try
          [data, fs] = audioread('audio.wav');
          sound(data, fs);
        catch
          disp('Error al Reproducir el audio.');
          
        end
      case 3
        % Grafico de audio
        try
          [data, fs] = audioread('audio.wav');
          tiempo = linspace(0, length(data)/fs, length(data));
          plot(tiempo, data);
          xlabel('Tiempo (s)');
          ylabel('Amplitud');
          title('Audio');
        catch
          disp('Error al graficar el audio.');
        end
      case 4 
        % Graficando espectro de Frecuencia
        try
          disp('Graficando espectro de frecuencia...');
          [audio, Fs] = audioread('audio.wav');
          N = length(audio);
          f = linspace(0, Fs/2, N/2+1);
          ventana = hann(N);
          Sxx = pwelch(audio, ventana, 0, N, Fs);
          plot(f, 10*log10(Sxx(1:N/2+1)));
          xlabel('Frecuencia (HZ)');
          ylabel('Densidad espectral de potencia (dB/HZ)');
          title('Espectro de frecuencia de la señal grabada');
        catch
          disp('Error al graficar audio.');
        end
      case 5
        % Salir
        disp('Saliendo del Programa');
      otherwise
        disp('Opcion no valida...');
        
    end
  
  
 end
  