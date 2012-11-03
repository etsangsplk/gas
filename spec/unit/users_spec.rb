require './spec/spec_helper'

require './lib/gas'

describe Gas::Users do

  before :each do
    @name = 'Fredrik Wallgren'
    @email = 'fredrik.wallgren@gmail.com'
    @nickname = 'walle'
    users = "[#{@nickname}]\n  name = #{@name}\n  email = #{@email}\n\n[user2]\n  name = foo\n  email = bar"
    @users = Gas::Users.new nil, users
  end

  it 'should be able to parse users from users format' do
    @users.users.count.should be 2
    @users.users[0].name.should eq @name
    @users.users[0].email.should eq @email
    @users.users[0].nickname.should eq @nickname
  end

  it 'should output the users in the correct format' do
    user1 = Gas::User.new 'Fredrik Wallgren', 'fredrik.wallgren@gmail.com', 'walle'
    user2 = Gas::User.new 'foo', 'bar', 'user2'
    users = [user1, user2]
    users = Gas::Users.new users

    mock(Gas::GitConfig).current_user { Gas::User.new 'foobar', 'test' }

    users.to_s.should == "      [walle]\n         name = Fredrik Wallgren\n         email = fredrik.wallgren@gmail.com\n      [user2]\n         name = foo\n         email = bar"
  end

  it 'should be able to tell if a nickname exists' do
    user1 = Gas::User.new 'Fredrik Wallgren', 'fredrik.wallgren@gmail.com', 'walle'
    user2 = Gas::User.new 'foo', 'bar', 'user2'
    users = [user1, user2]
    users = Gas::Users.new users
    users.exists?('walle').should be_true
    users.exists?('foo').should be_false
    users.exists?('user2').should be_true
  end

  it 'should be able to get a user from a nickname' do
    user1 = Gas::User.new 'Fredrik Wallgren', 'fredrik.wallgren@gmail.com', 'walle'
    user2 = Gas::User.new 'foo', 'bar', 'user2'
    users = [user1, user2]
    users = Gas::Users.new users
    users.get('walle').should eq user1
    users.get('user2').should eq user2
    users['walle'].should eq user1
    users['user2'].should eq user2
    users[:walle].should eq user1
    users[:user2].should eq user2
  end

  it 'should be able to add users' do
    user1 = Gas::User.new 'Fredrik Wallgren', 'fredrik.wallgren@gmail.com', 'walle'
    user2 = Gas::User.new 'foo', 'bar', 'user2'
    users = [user1]
    users = Gas::Users.new users
    users.users.count.should be 1
    users.add user2
    users.users.count.should be 2
  end

  it 'should be able to delete users by nickname' do
    user1 = Gas::User.new 'Fredrik Wallgren', 'fredrik.wallgren@gmail.com', 'walle'
    user2 = Gas::User.new 'foo', 'bar', 'user2'
    users = [user1, user2]
    users = Gas::Users.new users
    users.users.count.should be 2
    users.delete 'walle'
    users.users.count.should be 1
    users.delete 'user2'
    users.users.count.should be 0
  end
end