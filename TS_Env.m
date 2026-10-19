%All necessary data
data_1750 = tdmsread("torque-speed-1750RPM.tdms");
mat1750 = cell2mat(data_1750);
RPM_MAX_1750 = max(mat1750.EV_Measured_Speed);%RPM

data_2750 = tdmsread("torque-speed-2750RPM.tdms");
mat2750 = cell2mat(data_2750);
RPM_MAX_2750 = max(mat2750.EV_Measured_Speed);%RPM

data_3250 = tdmsread("torque-speed-3250RPM.tdms");
mat3250 = cell2mat(data_3250);
RPM_MAX_3250 = max(mat3250.EV_Measured_Speed);%RPM

data_3750 = tdmsread("torque-speed-3750RPM.tdms");
mat3750 = cell2mat(data_3750);
RPM_MAX_3750 = max(mat3750.EV_Measured_Speed);%RPM

data_4250 = tdmsread("torque-speed-4250RPM.tdms");
mat4250 = cell2mat(data_4250);
RPM_MAX_4250 = max(mat4250.EV_Measured_Speed);%RPM

data_4750 = tdmsread("torque-speed-4750RPM.tdms");
mat4750 = cell2mat(data_4750);
RPM_MAX_4750 = max(mat4750.EV_Measured_Speed);%RPM

data_5250 = tdmsread("torque-speed-5250RPM.tdms");
mat5250 = cell2mat(data_5250);
RPM_MAX_5250 = max(mat5250.EV_Measured_Speed);%RPM

rpmValues = [0 RPM_MAX_1750 RPM_MAX_2750 RPM_MAX_3250 RPM_MAX_3750 RPM_MAX_4250 RPM_MAX_4750 RPM_MAX_5250];
maxTorqueValues = [max(mat1750.("FMI 1")) max(mat1750.("FMI 1")) max(mat2750.("FMI 1")) ...
    max(mat3250.("FMI 1")) max(mat3750.("FMI 1")) max(mat4250.("FMI 1")) ...
    max(mat4750.("FMI 1")) max(mat5250.("FMI 1"))];

%Graphs
figure('Name', 'Raw Measured Data');
plot(rpmValues, maxTorqueValues,'LineWidth', 1.5);
xlim([0, inf]);
ylim([0, inf]);
xlabel("Speed (RPM)");
ylabel("Max Measured Torque (Nm)");
title("Measured Torque vs. Speed");
grid on;
grid minor;
%
figure('Name', 'Torque-Speed Envelope');
plot(rpmValues, maxTorqueValues, 'ko', 'MarkerFaceColor', 'k');
hold on;

cornerSpeed = max(mat1750.EV_Measured_Speed); 
isConstTorque = rpmValues <= cornerSpeed;
isConstPower  = rpmValues > cornerSpeed;

% Calculating fits, I feel that a polynomial of degree 2 is more fitting
% for the constant power region.
p_torque = polyfit(rpmValues(isConstTorque), maxTorqueValues(isConstTorque), 1);
p_power  = polyfit(rpmValues(isConstPower), maxTorqueValues(isConstPower), 2);

x_torque_fit = linspace(0, cornerSpeed, 100);
x_power_fit  = linspace(cornerSpeed, max(rpmValues), 100);

y_torque_fit = polyval(p_torque, x_torque_fit);
y_power_fit  = polyval(p_power, x_power_fit);

plot(x_torque_fit, y_torque_fit, 'r-', 'LineWidth', 2);
plot(x_power_fit, y_power_fit, 'b-', 'LineWidth', 2);

xlim([0, inf]);
ylim([0, inf]);
xlabel("Speed (RPM)");
ylabel("Max Measured Torque (Nm)");
title("Motor Torque-Speed Envelope & Linear/Poly Fits");
legend('Measured Points', 'Constant-Torque Fit', 'Constant-Power Fit', 'Location', 'northeast');
grid on;
grid minor;
hold off;