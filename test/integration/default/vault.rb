describe user('vault') do
    it { should exist }
    its('groups') { should eq ['vault', 'sudo'] }
    its('home') { should eq '/home/vault' }
end

describe file('/home/vault/install_vault.sh') do
    it { should exist }
    its('owner') { should eq 'vault' }
end