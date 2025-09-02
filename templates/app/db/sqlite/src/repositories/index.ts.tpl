import { setUserRepo } from "./user.repo";
import { prismaUserRepo } from "./user.repo.prisma";

setUserRepo(prismaUserRepo);
