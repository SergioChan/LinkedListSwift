#Swift 2.0:理解 flatMap

发布于2015年7月26日

上周我写了一篇关于我如何尝试创建一个非可选类型的有序图片数组的[博文](http://natashatherobot.com/swift-when-the-functional-approach-is-not-right/)。

当我在寻找最佳解决方案的时候，`flatMap`确实蹦进了我的脑海。但是老实说，我并不是很了解`flatMap`或者怎么去使用它。一个同事给我提供了一个使用了两个`flatMap`的解决方法，看起来十分的复杂难懂。

后来，经历了[博文的评论](http://natashatherobot.com/swift-when-the-functional-approach-is-not-right/)和[Twitter](https://twitter.com/NatashaTheRobot/status/624609007043391488)上的激烈讨论，我意识到解决方案其实可以是一种很简单的`flatMap`的用法：

```Swift
let minionImagesFlattened = (1...7).flatMap { UIImage(named: "minionIcon-\($0)") }
```

所以我在这里要将这次关于`flatMap`的激烈讨论转换为我是怎么理解它的过程，并且呈现给大家。记住我也是在不断地学习的，所以我肯定不是一个关于`flatMap`的专家！

## 简单的使用示范

我对于`flatMap`的理解十分的基础。这是我一开始的想法：

```Swift
let nestedArray = [[1,2,3], [4,5,6]]

let flattenedArray = nestedArray.flatMap { $0 }
flattenedArray // [1, 2, 3, 4, 5, 6]
```

## 转换元素😡

当我在写上面的例子的时候，我想做一件无比简单的事情 —— 让每个元素都乘以2，就像我用`map`那样。但是我却得到了这个：

![image](http://natashatherobot.com/wp-content/uploads/Screen-Shot-2015-07-26-at-5.50.07-AM.png)

不论我在`flatMap`的闭包里尝试什么都不起作用😢。于是我四处谷歌，万幸撞见了一篇之前就看过但是却没有认真阅读的来自[@sketchyTech](https://twitter.com/sketchyTech)的博文:[What do map() and flatMap() really do?](http://sketchytech.blogspot.com/2015/06/swift-what-do-map-and-flatmap-really-do.html)。去读一读吧，里面有很多关于`flatMap`的实用的东西！

我将要指出的部分，也是我从里面提取出来的最关键的部分：在`flatMap`中的$0指的是数组的数组中的任意一个数组！我竟然没想到！所以如果你想要将数组中的元素全部都乘以某个数字，你需要再深入一层并且使用`map`：

```Swift
let nestedArray = [[1,2,3], [4,5,6]]

let multipliedFlattenedArray = nestedArray.flatMap { $0.map { $0 * 2 } }
multipliedFlattenedArray // [2, 4, 6, 8, 10, 12]
```

这是完整的用名称来替代$0的写法，可以使它更加的容易理解：

```Swift
let nestedArray = [[1,2,3], [4,5,6]]

let multipliedFlattenedArray = nestedArray.flatMap { array in
    array.map { element in
        element * 2 }
}
multipliedFlattenedArray // [2, 4, 6, 8, 10, 12]
```

## flatMap + 可选类型

因为我想要用`flatMap`来处理嵌套数组，我花了很大功夫让自己能够理解该怎么样在我最初的问题中使用它：

```Swift
let minionImagesFlattened = (1...7).flatMap { UIImage(named: "minionIcon-\($0)") }
```

但是很明显，`flatMap`在遇到了可选类型的时候有着特殊的能力：

> [@NatashaTheRobot](https://twitter.com/NatashaTheRobot) 新的`flatMap`基本就是一个`map`，但是排除了`nil`值。换句话说，它会返回[T]，而不是[T?]。
> 
> — Dave DeLong (@davedelong)[7月 25, 2015](https://twitter.com/davedelong/status/624995473489682432)

当我看到了`flatMap`的方法定义的时候，我发现了这些，已经足以让我确定了：

```Swift
extension SequenceType {

    /// Return an `Array` containing concatenated results of mapping `transform`
    /// over `self`.
    func flatMap<S : SequenceType>(@noescape transform: (Self.Generator.Element) -> S) -> [S.Generator.Element]
}

extension SequenceType {

    /// Return an `Array` containing the non-nil results of mapping `transform`
    /// over `self`.
    func flatMap<T>(@noescape transform: (Self.Generator.Element) -> T?) -> [T]
}
```

换句话说，为了处理可选类型，`flatMap`被特殊的重载过了。它会输入一个可选类型的数组最终返回一个拆包过的且没有`nil`值的可选类型组成的数组。

```Swift
let optionalInts: [Int?] = [1, 2, nil, 4, nil, 5]

let ints = optionalInts.flatMap { $0 }
ints // [1, 2, 4, 5] - this is an [Int]
```

很棒也很方便的~但是这又怎么和上面这个展开嵌套数组的例子关联起来的呢？为什么`flatMap`被安排来做这个操作？我看过的最合理的解释来自于Lars-Jørgen Kristiansen的评论：

![image](http://natashatherobot.com/wp-content/uploads/Screen-Shot-2015-07-26-at-6.45.20-AM.png)

这种认为`flatMap`是在处理一个容器而不是仅仅数组的想法能让我们更好地去理解！

我明白我只是接触了关于`flatMap`的冰山一角，但是我觉得我至少在这之上有了一个起点去学习。祝大家学习Swift2.0快乐！