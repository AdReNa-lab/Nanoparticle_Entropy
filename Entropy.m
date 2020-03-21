function varargout = Entropy(varargin)

%Entropy_GUI

% Last Modified by GUIDE v2.5 21-Mar-2020 16:14:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Entropy_OpeningFcn, ...
                   'gui_OutputFcn',  @Entropy_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function Entropy_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
set(handles.Calculate,'Enable','off')
set(handles.Entropy_Mean, 'Enable', 'inactive')
set(handles.EStdDev, 'Enable', 'inactive')
set(handles.EnormMean, 'Enable', 'inactive')
set(handles.EnormStdDev, 'Enable', 'inactive')
set(handles.RI_mean, 'Enable', 'inactive')
set(handles.RI_StdDev, 'Enable', 'inactive')
set(handles.Min_Sample_Size, 'Enable', 'inactive')

set(handles.Unreliable, 'Enable', 'inactive')
set(handles.Reliable, 'Enable', 'inactive')

set(handles.Polydisperse, 'Enable', 'inactive')
set(handles.Near_monodisperse, 'Enable', 'inactive')
set(handles.Monodisperse, 'Enable', 'inactive')
set(handles.Highly_Monodisperse, 'Enable', 'inactive')

set(handles.RI_mean, 'BackgroundColor', [1,1,1]);
set(handles.RI_StdDev, 'BackgroundColor', [1,1,1]);
set(handles.EnormMean, 'BackgroundColor', [1,1,1]);
set(handles.EnormStdDev, 'BackgroundColor', [1,1,1]);


% Creates Reference message and url

labelStr = '<html>Thank you for citing. <a href="">';
jLabel = javaObjectEDT('javax.swing.JLabel', labelStr);
[~,~] = javacomponent(jLabel, [18,16,380,17], gcf);
url = 'https://doi.org/XXXXXX';
labelStr = ['<html>"Information Entropy as a Reliable Measure of Nanoparticle Dispersity" by Niamh Mac Fhionnlaoich et al.; Chem Mat. DOI: <a href="">' url '</a></html>' ];
jLabel = javaObjectEDT('javax.swing.JLabel', labelStr);
[hjLabel,~] = javacomponent(jLabel, [18,31,380,52], gcf);
hjLabel.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
hjLabel.setToolTipText('Visit the reference website');
set(hjLabel, 'MouseClickedCallback', @(h,e)web(url, '-browser'))

guidata(hObject, handles);

function varargout = Entropy_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function Import_Data_Callback(hObject, ~, handles) %#ok<*DEFNU>

try
    [name, path, idx] = uigetfile({'*.txt;*.xlsx;*.mat;*.xls;*.xlsm',...
    'Data Files (*.txt,*.xlsx,*.mat,*.xls,*.xlsm)'});

    [~,~,ext] = fileparts(name);

    t = fullfile(path, name);

    switch ext
        case '.mat'
            d = load(t);
            d2 = struct2cell(d);
            d3 = cell2mat(d2);
            Data = d3;

        case '.txt'
            d = importdata(t);
            t1 = isa(d,'double');
            t2 = isa(d,'struct');
            
            if t1 == 1
                Data = d;
            elseif t2 == 1
                Data = d.data;
            end
            
        otherwise
            prompt = {'Enter data range (e.g. A:A or A2:A101)', 'Enter sheet name'};
            dlgtitle = 'Excel Data';
            dims = [1 50];
            inputs = inputdlg(prompt,dlgtitle, dims);
            rng = char(inputs(1));
            sheet = char(inputs(2));
            Data = readmatrix(t,'Sheet',sheet,'Range',rng);
            
    end
    
       s = size(Data);
    if s(2) == 1
        handles.Data = Data;        
        set(handles.Calculate,'Enable','on')
        set(handles.Entropy_Mean,'String', ' ');
        set(handles.EStdDev,'String', ' ');
        set(handles.EnormMean,'String', ' ');
        set(handles.EnormStdDev,'String', ' ');
        set(handles.RI_mean,'String', ' ');
        set(handles.RI_StdDev,'String', ' ');
        set(handles.Min_Sample_Size,'String', ' ');
    else
        msg = 'Data is not in the correct format.';
        msg = [msg newline 'Data should be one column.'];
        warndlg(msg);
    end
    
            
    
catch
    
    if idx ~= 0
        msg = 'Something has gone wrong with importing the data.';
        warndlg(msg);
    end
    
end

guidata(hObject, handles);

function Import_Wksp_Callback(hObject, ~, handles)
try 
prompt = {'Enter variable name'};
dlgtitle = 'Import data from workspace';
dims = [1 50];
inputs = inputdlg(prompt,dlgtitle, dims);
str = char(inputs);
handles.Variable = str;
handles.Data = evalin('base', str);
Data = handles.Data; 

   s = size(Data);
    if s(2) == 1
        set(handles.Calculate,'Enable','on')
        set(handles.Entropy_Mean,'String', ' ');
        set(handles.EStdDev,'String', ' ');
        set(handles.EnormMean,'String', ' ');
        set(handles.EnormStdDev,'String', ' ');
        set(handles.RI_mean,'String', ' ');
        set(handles.RI_StdDev,'String', ' ');
        set(handles.Min_Sample_Size,'String', ' ');
    else
        msg = 'Data is not in the correct format.';
        msg = [msg newline 'Data should be one column.'];
        warndlg(msg);
    end
    
catch
    
    if idx ~= 0
        msg = 'Something has gone wrong with importing the data.';
        warndlg(msg);
    end
    
end

guidata(hObject, handles);

function Reps_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Reps_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Bin_Width_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Bin_Width_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Calculate_Callback(hObject, ~, handles)
reps = str2double(get(handles.Reps,'String'));

if isnumeric(reps) == 0
    reps = 0;
    
elseif reps == Inf
    reps = 0;
    
elseif isnan(reps) == 1
    reps = 0;
    
end

bw = str2double(get(handles.Bin_Width, 'String'));

Test_bw = isnumeric(bw);
if Test_bw == 1
    if isnan(bw) == 1
        check_bw = 0;
    elseif bw == Inf
        check_bw = 0;
    else
        check_bw = 1;
    end
end

if check_bw == 1
Pop = handles.Data;

n = reps + 1;

E_temp = zeros(n,1);
RI_temp =zeros(n,1);
E_temp_data = zeros(n,1);
RI_temp_data =zeros(n,1);
counter = 0;
str = 'Calculations in progress...';
set(handles.Calculating_Status_Text, 'String', str);
while counter < n
    
    [E_temp_, RI_temp_] = Entropy_Function(Pop, bw);
    
    if RI_temp_ > 0
        counter = counter + 1;
        stra = 'Calculations in progress...  \nCalculating iteration %d of %d';
        str = sprintf(stra, counter, n);
        set(handles.Calculating_Status_Text, 'String', str);
        E_temp(counter) = E_temp_;
        RI_temp(counter) = RI_temp_;
        %E_temp_data{counter} = cellstr(sprintf('%.5g', E_temp_));
        %RI_temp_data{counter} = cellstr(sprintf('%.5g', RI_temp_));
    end
end

Table_Data = [E_temp, RI_temp./(10^-3)];
set(handles.Data_Table,'data',Table_Data);
Row_names = 1:1:length(Pop);
Row_names_cell = num2cell(Row_names);
set(handles.Data_Table,'RowName', Row_names_cell);

Em = (mean(E_temp));
Es = (std(E_temp));
En = (Em/mean(Pop));
Ens = En/Em*Es;
RIm = mean(RI_temp);
RIs = std(RI_temp);

Em_str = sprintf('%.5g', Em);
Es_str = sprintf('%.5g', Es);
En_str = sprintf('%.5g', En);
Ens_str = sprintf('%.5g', Ens);
RIm_str = sprintf('%.5g', RIm);
RIs_str = sprintf('%.5g', RIs);

set(handles.Entropy_Mean, 'String', Em_str);
set(handles.EStdDev, 'String', Es_str);
set(handles.EnormMean, 'String', En_str);
set(handles.EnormStdDev, 'String', Ens_str);
set(handles.RI_mean, 'String', RIm_str);
set(handles.RI_StdDev, 'String', RIs_str);

if En > 0.618
    set(handles.EnormMean, 'BackgroundColor', [231/255, 128/255, 91/255]);
    set(handles.EnormStdDev, 'BackgroundColor', [231/255, 128/255, 91/255]);

elseif En > 0.206
    set(handles.EnormMean, 'BackgroundColor', [255/255, 191/255, 96/255]);
    set(handles.EnormStdDev, 'BackgroundColor', [255/255, 191/255, 96/255]);
    
elseif En > 0.125
    set(handles.EnormMean, 'BackgroundColor', [255/255, 227/255, 137/255]);
    set(handles.EnormStdDev, 'BackgroundColor', [255/255, 227/255, 137/255]);
    
elseif En > 0
    set(handles.EnormMean, 'BackgroundColor', [215/255, 238/255, 168/255]);
    set(handles.EnormStdDev, 'BackgroundColor', [215/255, 238/255, 168/255]);
end
    

if RIm > 0.02*bw
    
    y0 = 0.0935;
    A1 = -0.0741;
    A2 = -0.0193;
    tratio = 4.674;
    sn = length(Pop);
    %RI_fun = strcat(num2str(y0), '+', num2str(A1), '*(1-exp(-x/t)) +',...
     %   num2str(A2), '*(1-exp(-x/(', num2str(tratio), '*t)))');
    
    RI_fun = @(t) y0 + A1 * (1 - exp(-sn/t)) + A2 * (1 - exp(-sn/(tratio * t))) - RIm;
    
    
    t_start = 100;
    
   
    check = 0;
    MaxIter = 10;
    iter = 0;
    while check == 0
        
        %fitops = fitoptions('TolFun', 0.025*bw*0.01); 
        t_val = fzero(RI_fun, t_start);
        
        if t_val <=0 
            t_start = t_start*1.1;
            
            if iter < MaxIter
                check = 0;
            else
                check = 1;
            end
            
        else
            check = 1;
        end
        
    end
    
    RI_fun_samplesize = @(x) y0 + A1 * (1 - exp(-x/t_val)) + A2 * (1 - exp(-x/(tratio * t_val))) - 0.025 * bw;
    
    Min_Sample_Size_Estimate = fzero(RI_fun_samplesize, length(Pop));
    power = round(log10(Min_Sample_Size_Estimate))-1;
    rnd_factor = 10^power * 0.5;
    Min_Sample_Size_Estimate_rounded = round(Min_Sample_Size_Estimate/rnd_factor)*rnd_factor;
    set(handles.Min_Sample_Size, 'String', Min_Sample_Size_Estimate_rounded);
    
    set(handles.RI_mean, 'BackgroundColor', [1,0,0]);
    set(handles.RI_mean, 'BackgroundColor', [231/255, 128/255, 91/255]);
    set(handles.RI_StdDev, 'BackgroundColor', [231/255, 128/255, 91/255]);
    
else
    
    set(handles.Min_Sample_Size, 'String', 'n/a');
    set(handles.RI_mean, 'BackgroundColor', [215/255, 238/255, 168/255]);
    set(handles.RI_StdDev, 'BackgroundColor', [215/255, 238/255, 168/255]);
    
end

else
   warndlg('Bin Width Required.','Error');

end    
 
set(handles.Calculate,'Enable','on')

guidata(hObject, handles);

function Entropy_Mean_Callback(hObject, ~, handles)

guidata(hObject, handles);

function Entropy_Mean_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EnormMean_Callback(hObject, ~, handles)
guidata(hObject, handles);

function EnormMean_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EStdDev_Callback(hObject, ~, handles)
guidata(hObject, handles);

function EStdDev_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EnormStdDev_Callback(hObject, ~, handles)
guidata(hObject, handles);

function EnormStdDev_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Min_Sample_Size_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Min_Sample_Size_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function RI_mean_Callback(hObject, ~, handles)
guidata(hObject, handles);

function RI_mean_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function RI_StdDev_Callback(hObject, ~, handles)
guidata(hObject, handles);

function RI_StdDev_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Monodisperse_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Monodisperse_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Polydisperse_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Polydisperse_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Highly_Monodisperse_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Highly_Monodisperse_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Near_monodisperse_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Near_monodisperse_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Unreliable_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Unreliable_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Reliable_Callback(hObject, ~, handles)
guidata(hObject, handles);

function Reliable_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
