mod dbus_server {
    #![allow(clippy::too_many_arguments)]
    include!(concat!(env!("OUT_DIR"), "/introspection.rs"));
}

pub struct DbusNotification {

}

impl dbus_server::OrgFreedesktopNotifications for DbusNotification {
    fn get_server_information(&mut self) -> Result<(String,String,String,String),dbus::MethodErr> {
        todo!()
    }

    fn get_capabilities(&mut self) -> Result<Vec<String>,dbus::MethodErr> {
        todo!()
    }

    fn close_notification(&mut self,id:u32) -> Result<(),dbus::MethodErr> {
        todo!()
    }

    fn notify(&mut self,app_name:String,id:u32,icon:String,summary:String,body:String,actions:Vec<String>,hints:dbus::arg::PropMap,timeout:i32) -> Result<u32,dbus::MethodErr> {
        todo!()
    }
}
