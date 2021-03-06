/* The Computer Language Benchmarks Game
 * Written in OOC language
 * Hongjie Zhai
 */
Node: class{
	item: Int
	left,right: Node

	init: func(depth: Int, =item){
		if(depth<=0) return
		left = Node new(depth-1, 2*item-1);
		right = Node new(depth-1, 2*item);
	}

	itemCheck: func() -> Int{
		if(!left) return item
		return item+left itemCheck()-right itemCheck()
	}

    free: func{
        version(!gc){
            if(left) left free()
            if(right) right free()
        }
    }
}

mindep := 4
main: func(argv: Int, argc: CString*) -> Int{
	depth: Int
	if(argv>1) depth = argc[1] toString() toInt()
	else return 1
	stretch := depth+1
    checknode := Node new(stretch, 0)
	check := checknode itemCheck()
	"stretch tree of depth %d\t check: %d" printfln(stretch, check)
	longlived := Node new(depth,0)
	i := mindep
	while(i<=depth){
		iterations := 1<<(depth-i+mindep)
		check: Int = 0
		for(j in 1..iterations+1){
            version(!gc){
                a := Node new(i,j)
                check += a itemCheck()
                a free()

                b := Node new(i,-j)
                check += b itemCheck()
                b free()
            } else {
                check += Node new(i,j) itemCheck()
                check += Node new(i,-j) itemCheck()
            }
		}
		"%d\ttrees of depth %d\t check: %d" printfln(iterations*2, i, check);
		i+=2
	}
	"long lived tree fo depth %d\t check %d" printfln(depth, longlived.itemCheck());
    longlived free()
    checknode free()
	return 0
}

