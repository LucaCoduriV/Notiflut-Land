use dbus as dbus;
#[allow(unused_imports)]
use dbus::arg;
use dbus_crossroads as crossroads;

pub trait OrgFreedesktopNotifications {
    fn notify(&mut self, app_name: String, replaces_id: u32, app_icon: String, summary: String, body: String, actions: Vec<String>, hints: arg::PropMap, timeout: i32) -> Result<u32, dbus::MethodErr>;
    fn close_notification(&mut self, id: u32) -> Result<(), dbus::MethodErr>;
    fn get_capabilities(&mut self) -> Result<Vec<String>, dbus::MethodErr>;
    fn get_server_information(&mut self) -> Result<(String, String, String, String), dbus::MethodErr>;
}

#[derive(Debug)]
pub struct OrgFreedesktopNotificationsNotificationClosed {
    pub id: u32,
    pub reason: u32,
}

impl arg::AppendAll for OrgFreedesktopNotificationsNotificationClosed {
    fn append(&self, i: &mut arg::IterAppend) {
        arg::RefArg::append(&self.id, i);
        arg::RefArg::append(&self.reason, i);
    }
}

impl arg::ReadAll for OrgFreedesktopNotificationsNotificationClosed {
    fn read(i: &mut arg::Iter) -> Result<Self, arg::TypeMismatchError> {
        Ok(OrgFreedesktopNotificationsNotificationClosed {
            id: i.read()?,
            reason: i.read()?,
        })
    }
}

impl dbus::message::SignalArgs for OrgFreedesktopNotificationsNotificationClosed {
    const NAME: &'static str = "NotificationClosed";
    const INTERFACE: &'static str = "org.freedesktop.Notifications";
}

#[derive(Debug)]
pub struct OrgFreedesktopNotificationsActionInvoked {
    pub id: u32,
    pub action_key: String,
}

impl arg::AppendAll for OrgFreedesktopNotificationsActionInvoked {
    fn append(&self, i: &mut arg::IterAppend) {
        arg::RefArg::append(&self.id, i);
        arg::RefArg::append(&self.action_key, i);
    }
}

impl arg::ReadAll for OrgFreedesktopNotificationsActionInvoked {
    fn read(i: &mut arg::Iter) -> Result<Self, arg::TypeMismatchError> {
        Ok(OrgFreedesktopNotificationsActionInvoked {
            id: i.read()?,
            action_key: i.read()?,
        })
    }
}

impl dbus::message::SignalArgs for OrgFreedesktopNotificationsActionInvoked {
    const NAME: &'static str = "ActionInvoked";
    const INTERFACE: &'static str = "org.freedesktop.Notifications";
}

pub fn register_org_freedesktop_notifications<T>(cr: &mut crossroads::Crossroads) -> crossroads::IfaceToken<T>
where T: OrgFreedesktopNotifications + Send + 'static
{
    cr.register("org.freedesktop.Notifications", |b| {
        b.signal::<(u32,u32,), _>("NotificationClosed", ("id","reason",));
        b.signal::<(u32,String,), _>("ActionInvoked", ("id","action_key",));
        b.method("Notify", ("app_name","replaces_id","app_icon","summary","body","actions","hints","timeout",), ("",), |_, t: &mut T, (app_name,replaces_id,app_icon,summary,body,actions,hints,timeout,)| {
            t.notify(app_name,replaces_id,app_icon,summary,body,actions,hints,timeout,)
                .map(|x| (x,))
        })
            .annotate("org.qtproject.QtDBus.QtTypeName.In6", "QVariantMap");
        b.method("CloseNotification", ("id",), (), |_, t: &mut T, (id,)| {
            t.close_notification(id,)
        });
        b.method("GetCapabilities", (), ("caps",), |_, t: &mut T, ()| {
            t.get_capabilities()
                .map(|x| (x,))
        });
        b.method("GetServerInformation", (), ("name","vendor","version","spec_version",), |_, t: &mut T, ()| {
            t.get_server_information()
        });
    })
}
