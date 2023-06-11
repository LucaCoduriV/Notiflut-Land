use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_setup(port_: i64) {
    wire_setup_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_start_daemon(port_: i64) {
    wire_start_daemon_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_stop_daemon(port_: i64) {
    wire_stop_daemon_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_send_daemon_action(port_: i64, action: *mut wire_DaemonAction) {
    wire_send_daemon_action_impl(port_, action)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_StringList_0(len: i32) -> *mut wire_StringList {
    let wrap = wire_StringList {
        ptr: support::new_leak_vec_ptr(<*mut wire_uint_8_list>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_bool_0(value: bool) -> *mut bool {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_daemon_action_0() -> *mut wire_DaemonAction {
    support::new_leak_box_ptr(wire_DaemonAction::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_i32_0(value: i32) -> *mut i32 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_image_data_0() -> *mut wire_ImageData {
    support::new_leak_box_ptr(wire_ImageData::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_image_source_0() -> *mut wire_ImageSource {
    support::new_leak_box_ptr(wire_ImageSource::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_notification_0() -> *mut wire_Notification {
    support::new_leak_box_ptr(wire_Notification::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_urgency_0(value: i32) -> *mut i32 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_usize_0(value: usize) -> *mut usize {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_list_notification_0(len: i32) -> *mut wire_list_notification {
    let wrap = wire_list_notification {
        ptr: support::new_leak_vec_ptr(<wire_Notification>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<Vec<String>> for *mut wire_StringList {
    fn wire2api(self) -> Vec<String> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<bool> for *mut bool {
    fn wire2api(self) -> bool {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<DaemonAction> for *mut wire_DaemonAction {
    fn wire2api(self) -> DaemonAction {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<DaemonAction>::wire2api(*wrap).into()
    }
}
impl Wire2Api<i32> for *mut i32 {
    fn wire2api(self) -> i32 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<ImageData> for *mut wire_ImageData {
    fn wire2api(self) -> ImageData {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ImageData>::wire2api(*wrap).into()
    }
}
impl Wire2Api<ImageSource> for *mut wire_ImageSource {
    fn wire2api(self) -> ImageSource {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<ImageSource>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Notification> for *mut wire_Notification {
    fn wire2api(self) -> Notification {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Notification>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Urgency> for *mut i32 {
    fn wire2api(self) -> Urgency {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Urgency>::wire2api(*wrap).into()
    }
}
impl Wire2Api<usize> for *mut usize {
    fn wire2api(self) -> usize {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<DaemonAction> for wire_DaemonAction {
    fn wire2api(self) -> DaemonAction {
        match self.tag {
            0 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Show);
                DaemonAction::Show(ans.field0.wire2api())
            },
            1 => DaemonAction::ShowNc,
            2 => DaemonAction::CloseNc,
            3 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Close);
                DaemonAction::Close(ans.field0.wire2api())
            },
            4 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Update);
                DaemonAction::Update(ans.field0.wire2api(), ans.field1.wire2api())
            },
            5 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.FlutterClose);
                DaemonAction::FlutterClose(ans.field0.wire2api())
            },
            6 => DaemonAction::FlutterCloseAll,
            7 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.FlutterCloseAllApp);
                DaemonAction::FlutterCloseAllApp(ans.field0.wire2api())
            },
            8 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.FlutterActionInvoked);
                DaemonAction::FlutterActionInvoked(ans.field0.wire2api(), ans.field1.wire2api())
            },
            _ => unreachable!(),
        }
    }
}
impl Wire2Api<Hints> for wire_Hints {
    fn wire2api(self) -> Hints {
        Hints {
            actions_icon: self.actions_icon.wire2api(),
            category: self.category.wire2api(),
            desktop_entry: self.desktop_entry.wire2api(),
            resident: self.resident.wire2api(),
            sound_file: self.sound_file.wire2api(),
            sound_name: self.sound_name.wire2api(),
            suppress_sound: self.suppress_sound.wire2api(),
            transient: self.transient.wire2api(),
            x: self.x.wire2api(),
            y: self.y.wire2api(),
            urgency: self.urgency.wire2api(),
        }
    }
}

impl Wire2Api<ImageData> for wire_ImageData {
    fn wire2api(self) -> ImageData {
        ImageData {
            width: self.width.wire2api(),
            height: self.height.wire2api(),
            rowstride: self.rowstride.wire2api(),
            one_point_two_bit_alpha: self.one_point_two_bit_alpha.wire2api(),
            bits_per_sample: self.bits_per_sample.wire2api(),
            channels: self.channels.wire2api(),
            data: self.data.wire2api(),
        }
    }
}
impl Wire2Api<ImageSource> for wire_ImageSource {
    fn wire2api(self) -> ImageSource {
        match self.tag {
            0 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Data);
                ImageSource::Data(ans.field0.wire2api())
            },
            1 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Path);
                ImageSource::Path(ans.field0.wire2api())
            },
            _ => unreachable!(),
        }
    }
}
impl Wire2Api<Vec<Notification>> for *mut wire_list_notification {
    fn wire2api(self) -> Vec<Notification> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}
impl Wire2Api<Notification> for wire_Notification {
    fn wire2api(self) -> Notification {
        Notification {
            id: self.id.wire2api(),
            app_name: self.app_name.wire2api(),
            replaces_id: self.replaces_id.wire2api(),
            summary: self.summary.wire2api(),
            body: self.body.wire2api(),
            actions: self.actions.wire2api(),
            timeout: self.timeout.wire2api(),
            created_at: self.created_at.wire2api(),
            hints: self.hints.wire2api(),
            app_icon: self.app_icon.wire2api(),
            app_image: self.app_image.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_StringList {
    ptr: *mut *mut wire_uint_8_list,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Hints {
    actions_icon: *mut bool,
    category: *mut wire_uint_8_list,
    desktop_entry: *mut wire_uint_8_list,
    resident: *mut bool,
    sound_file: *mut wire_uint_8_list,
    sound_name: *mut wire_uint_8_list,
    suppress_sound: *mut bool,
    transient: *mut bool,
    x: *mut i32,
    y: *mut i32,
    urgency: *mut i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ImageData {
    width: i32,
    height: i32,
    rowstride: i32,
    one_point_two_bit_alpha: bool,
    bits_per_sample: i32,
    channels: i32,
    data: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_notification {
    ptr: *mut wire_Notification,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Notification {
    id: u32,
    app_name: *mut wire_uint_8_list,
    replaces_id: u32,
    summary: *mut wire_uint_8_list,
    body: *mut wire_uint_8_list,
    actions: *mut wire_StringList,
    timeout: i32,
    created_at: i64,
    hints: wire_Hints,
    app_icon: *mut wire_ImageSource,
    app_image: *mut wire_ImageSource,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction {
    tag: i32,
    kind: *mut DaemonActionKind,
}

#[repr(C)]
pub union DaemonActionKind {
    Show: *mut wire_DaemonAction_Show,
    ShowNc: *mut wire_DaemonAction_ShowNc,
    CloseNc: *mut wire_DaemonAction_CloseNc,
    Close: *mut wire_DaemonAction_Close,
    Update: *mut wire_DaemonAction_Update,
    FlutterClose: *mut wire_DaemonAction_FlutterClose,
    FlutterCloseAll: *mut wire_DaemonAction_FlutterCloseAll,
    FlutterCloseAllApp: *mut wire_DaemonAction_FlutterCloseAllApp,
    FlutterActionInvoked: *mut wire_DaemonAction_FlutterActionInvoked,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_Show {
    field0: *mut wire_Notification,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_ShowNc {}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_CloseNc {}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_Close {
    field0: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_Update {
    field0: *mut wire_list_notification,
    field1: *mut usize,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_FlutterClose {
    field0: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_FlutterCloseAll {}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_FlutterCloseAllApp {
    field0: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_DaemonAction_FlutterActionInvoked {
    field0: u32,
    field1: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ImageSource {
    tag: i32,
    kind: *mut ImageSourceKind,
}

#[repr(C)]
pub union ImageSourceKind {
    Data: *mut wire_ImageSource_Data,
    Path: *mut wire_ImageSource_Path,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ImageSource_Data {
    field0: *mut wire_ImageData,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_ImageSource_Path {
    field0: *mut wire_uint_8_list,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_DaemonAction {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_DaemonAction_Show() -> *mut DaemonActionKind {
    support::new_leak_box_ptr(DaemonActionKind {
        Show: support::new_leak_box_ptr(wire_DaemonAction_Show {
            field0: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_DaemonAction_Close() -> *mut DaemonActionKind {
    support::new_leak_box_ptr(DaemonActionKind {
        Close: support::new_leak_box_ptr(wire_DaemonAction_Close {
            field0: Default::default(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_DaemonAction_Update() -> *mut DaemonActionKind {
    support::new_leak_box_ptr(DaemonActionKind {
        Update: support::new_leak_box_ptr(wire_DaemonAction_Update {
            field0: core::ptr::null_mut(),
            field1: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_DaemonAction_FlutterClose() -> *mut DaemonActionKind {
    support::new_leak_box_ptr(DaemonActionKind {
        FlutterClose: support::new_leak_box_ptr(wire_DaemonAction_FlutterClose {
            field0: Default::default(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_DaemonAction_FlutterCloseAllApp() -> *mut DaemonActionKind {
    support::new_leak_box_ptr(DaemonActionKind {
        FlutterCloseAllApp: support::new_leak_box_ptr(wire_DaemonAction_FlutterCloseAllApp {
            field0: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_DaemonAction_FlutterActionInvoked() -> *mut DaemonActionKind {
    support::new_leak_box_ptr(DaemonActionKind {
        FlutterActionInvoked: support::new_leak_box_ptr(wire_DaemonAction_FlutterActionInvoked {
            field0: Default::default(),
            field1: core::ptr::null_mut(),
        }),
    })
}

impl NewWithNullPtr for wire_Hints {
    fn new_with_null_ptr() -> Self {
        Self {
            actions_icon: core::ptr::null_mut(),
            category: core::ptr::null_mut(),
            desktop_entry: core::ptr::null_mut(),
            resident: core::ptr::null_mut(),
            sound_file: core::ptr::null_mut(),
            sound_name: core::ptr::null_mut(),
            suppress_sound: core::ptr::null_mut(),
            transient: core::ptr::null_mut(),
            x: core::ptr::null_mut(),
            y: core::ptr::null_mut(),
            urgency: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Hints {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ImageData {
    fn new_with_null_ptr() -> Self {
        Self {
            width: Default::default(),
            height: Default::default(),
            rowstride: Default::default(),
            one_point_two_bit_alpha: Default::default(),
            bits_per_sample: Default::default(),
            channels: Default::default(),
            data: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_ImageData {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_ImageSource {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_ImageSource_Data() -> *mut ImageSourceKind {
    support::new_leak_box_ptr(ImageSourceKind {
        Data: support::new_leak_box_ptr(wire_ImageSource_Data {
            field0: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_ImageSource_Path() -> *mut ImageSourceKind {
    support::new_leak_box_ptr(ImageSourceKind {
        Path: support::new_leak_box_ptr(wire_ImageSource_Path {
            field0: core::ptr::null_mut(),
        }),
    })
}

impl NewWithNullPtr for wire_Notification {
    fn new_with_null_ptr() -> Self {
        Self {
            id: Default::default(),
            app_name: core::ptr::null_mut(),
            replaces_id: Default::default(),
            summary: core::ptr::null_mut(),
            body: core::ptr::null_mut(),
            actions: core::ptr::null_mut(),
            timeout: Default::default(),
            created_at: Default::default(),
            hints: Default::default(),
            app_icon: core::ptr::null_mut(),
            app_image: core::ptr::null_mut(),
        }
    }
}

impl Default for wire_Notification {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
