require 'spec_helper'

describe 'yum-chef::default' do
  context 'cookbook attributes are overriden on centos 6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '6'
      ) do |node|
        node.override['yum-chef'].tap do |yum|
          yum['repositoryid'] = 'chef-nightly'
          yum['baseurl'] = 'https://example.com/chef/nightly/5/$basearch'
          yum['gpgkey'] = 'https://example.com/package-public.key'
          yum['proxy'] = 'http://proxy.example.com:3128'
          yum['proxy_username'] = 'wornin'
          yum['proxy_password'] = 'illisit'
        end
      end.converge(described_recipe)
    end

    it 'renders the yum repository from attributes' do
      expect(chef_run).to create_yum_repository('chef-nightly').with(
        repositoryid: 'chef-nightly',
        baseurl: 'https://example.com/chef/nightly/5/$basearch',
        gpgkey: 'https://example.com/package-public.key',
        proxy: 'http://proxy.example.com:3128',
        proxy_username: 'wornin',
        proxy_password: 'illisit'
      )
    end
  end

  context 'cookbook attributes are default on centos-7.0' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '7'
      ).converge(described_recipe)
    end

    it 'renders the yum repository with defaults' do
      expect(chef_run).to create_yum_repository('chef-stable').with(
        repositoryid: 'chef-stable',
        baseurl: 'https://packages.chef.io/stable-yum/el/7/$basearch'
      )
    end
  end

  context 'cookbook attributes are default on amazon linux' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'amazon',
        version: '2016.03'
      ).converge(described_recipe)
    end

    it 'renders the yum repository with defaults' do
      expect(chef_run).to create_yum_repository('chef-stable').with(
        repositoryid: 'chef-stable',
        baseurl: 'https://packages.chef.io/stable-yum/el/6/$basearch'
      )
    end
  end
end
