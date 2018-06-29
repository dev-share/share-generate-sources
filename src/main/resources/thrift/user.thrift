namespace cpp com.devzy.share.thrift 
namespace java com.devzy.share.thrift

struct EntUserBean {
    1:i64 EntUserID;    
    2:string login; 
    3:string loginType;
    4:string extend;
    5:string userid;
}

struct UserBean {
    1:i64 id;   
    2:string name;  
    3:string nickName;
    4:string extend;
}

service  IUserDao{
  list<UserBean> queryAllEntUser();
  i32 addUserBean(1:UserBean user);
  UserBean updateUserBean(1:UserBean user);
  UserBean queryUserBean(1:i64 userID);
  UserBean deleteUserBean(1:i64 userID);
}

service  IEntUserDao{
  list<EntUserBean> queryAllEntUser();
  i32 addEntUser(1:EntUserBean user);
  EntUserBean updateEntUserBean(1:EntUserBean user);
  EntUserBean queryEntUserBean(1:i64 userID);
  EntUserBean deleteEntUserBean(1:i64 userID);
}