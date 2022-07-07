from typing import Any, Dict, Mapping, TypeVar

T = TypeVar("T", bound="DataClassDictMixin")

class DataClassDictMixin:
    def __init_subclass__(cls, **kwargs): ...
    def to_dict(
        self, use_bytes: bool = ..., use_enum: bool = ..., use_datetime: bool = ..., **kwargs
    ) -> dict: ...
    @classmethod
    def from_dict(
        cls,
        d: Mapping,
        use_bytes: bool = ...,
        use_enum: bool = ...,
        use_datetime: bool = ...,
        **kwargs,
    ) -> T: ...
    @classmethod
    def __pre_deserialize__(cls, d: Dict[Any, Any]) -> Dict[Any, Any]: ...
    @classmethod
    def __post_deserialize__(cls, obj: T) -> T: ...
    def __pre_serialize__(self) -> T: ...
    def __post_serialize__(self, d: Dict[Any, Any]) -> Dict[Any, Any]: ...
