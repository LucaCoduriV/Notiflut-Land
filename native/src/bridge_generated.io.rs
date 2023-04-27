use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_setup(port_: i64) {
    wire_setup_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_start_deamon(port_: i64) {
    wire_start_deamon_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_stop_deamon(port_: i64) {
    wire_stop_deamon_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_create_sink(port_: i64) {
    wire_create_sink_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_generate_number(port_: i64) {
    wire_generate_number_impl(port_)
}

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

// Section: wire structs

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
