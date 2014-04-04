%adapted and modified from "Learning the Kalman Filter" http://www.mathworks.com/matlabcentral/fileexchange/5377-learning-the-kalman-filter


function m = kalmanf(m)

% defaults, initialize struct m
if ~isfield(m,'x'); m.x=nan*z; end
if ~isfield(m,'P'); m.P=nan; end
if ~isfield(m,'z'); error('Observation vector missing'); end
if ~isfield(m,'w'); m.w=0; end
if ~isfield(m,'A'); m.A=eye(length(x)); end
if ~isfield(m,'B'); m.B=0; end
if ~isfield(m,'Q'); m.Q=zeros(length(x)); end
if ~isfield(m,'R'); error('Observation covariance missing'); end
if ~isfield(m,'H'); m.H=eye(length(x)); end

if isnan(m.x)
   % use first observation to intiatalize
   m.x = inv(m.H)*m.z;
   m.P = inv(m.H)*m.R*inv(m.H'); 
else
   % Run Kalman Filter   
   % Prediction for state vector and covariance:
   m.x = m.A*m.x + m.B*m.w;
   m.P = m.A * m.P * m.A' + m.Q;

   % Compute Kalman gain factor:
   K = m.P*m.H'*inv(m.H*m.P*m.H'+m.R);

   % Correction based on observation:
   m.x = m.x + K*(m.z-m.H*m.x);
   m.P = m.P - K*m.H*m.P;
   
end

return


  
