describe package('jq') do
  it { should be_installed }
end

describe package('curl') do
  it { should be_installed }
end

describe package('unzip') do
  it { should be_installed }
end

describe package('vim') do
  it { should be_installed }
end

describe package('tmux') do
  it { should be_installed }
end

describe package('cloud-init') do
  it { should be_installed }
end
