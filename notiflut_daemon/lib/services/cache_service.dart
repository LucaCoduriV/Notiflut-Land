// TODO FIND A WAY TO CLEAR RAM
class CacheService<T, S>{
  final Map<T, S> _cache = {};

  S? get(T key){
    return _cache[key];
  }

  void put(T key, S data){
    _cache[key] = data;
  }

  S? getOrPut(T key, S? Function() provider){
    final oldCache = _cache[key];
    if(oldCache != null){
      return oldCache;
    }

    final newCache = provider();
    if(newCache != null){
      _cache[key] = newCache;
    }
    return newCache;
  }
}
